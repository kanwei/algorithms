/*
 * :main:CPriorityQueue
 *
 * Ruby extension implementing a priority queue
 * 
 * This is a fibonacci heap priority queue implementation.
 *
 * (c) 2005 Brian Schröder
 * 
 * Please submit bugreports to priority_queue@brian-schroeder.de
 *
 * This extension is under the same license as ruby.
 * 
 * Do not hold me reliable for anything that happens to you, your programs or
 * anything else because of this extension. It worked for me, but there is no
 * guarantee it will work for you.
 *
 * Except for using a value except of a void* the priority queue c-code is ruby
 * agnostic.
 *
 */
#include <stdlib.h>
#include <stdio.h>
#include "ruby.h"
#include <math.h>

typedef _Bool bool;

#define false 0;
#define true 1;

// Node Structure
typedef struct struct_priority_node {
  unsigned int degree;
  VALUE priority;
  VALUE object;
  struct struct_priority_node* parent;
  struct struct_priority_node* child;
  struct struct_priority_node* left;
  struct struct_priority_node* right;
  bool mark;
} priority_node;

// The Priority Queue
typedef struct {
  priority_node* rootlist;
  priority_node* min;
  unsigned int length;
  int (*compare_function)(VALUE p1, VALUE p2); // Should return < 0 for a < b, 0 for a == b, > 0 for a > b
} priority_queue;

////////////////////////////////////////////////////////////////////////////////
// Node Manipulation Functions
////////////////////////////////////////////////////////////////////////////////

// Create a priority node structure
priority_node* create_priority_node(VALUE object, VALUE priority) {
  priority_node* result = ALLOC(priority_node);
  result->degree   = 0;
  result->priority = priority;
  result->object = object;
  result->parent = NULL;
  result->child = NULL;
  result->left = result;
  result->right = result;
  result->mark = false;  
  return result;
}

// Use this to free a node struct
void priority_node_free(priority_node* n) {
  free(n);
}

static
void priority_node_free_recursively(priority_node* n) {
  if (!n)
    return;

  priority_node* n1 = n;
  do {
    priority_node *n2 = n1->right;
    priority_node_free_recursively(n1->child);
    priority_node_free(n1);
    n1 = n2;
  } while(n1 != n);
}

// link two binomial heaps
static 
priority_node* link_nodes(priority_queue* q, priority_node* b1, priority_node* b2) {
  if (q->compare_function(b2->priority, b1->priority) < 0)
    return link_nodes(q, b2, b1);
  b2->parent = b1;
  priority_node* child = b1->child;
  b1->child = b2;
  if (child) {
    b2->left  = child->left;
    b2->left->right = b2;
    b2->right = child;
    b2->right->left = b2;
  } else {
    b2->left = b2;
    b2->right = b2;
  }
  b1->degree++;
  b2->mark = false; // TODO: Check if it is not rather b1 that should be marked as false
  return b1;
}

////////////////////////////////////////////////////////////////////////////////
// Queue Manipulation Functions
////////////////////////////////////////////////////////////////////////////////

// Create an empty priority queue
priority_queue* create_priority_queue(int (*compare_function)(VALUE, VALUE)) {
  priority_queue *result = ALLOC(priority_queue);
  result->min = NULL;
  result->rootlist = NULL;
  result->length = 0;
  result->compare_function = compare_function;
  return result;
}

// Free a priority queue and all the nodes it contains
void priority_queue_free(priority_queue* q) {
  priority_node_free_recursively(q->rootlist);
  free(q);
}

// Insert a node into the rootlist
// Does not change length value
static
priority_queue* insert_tree(priority_queue* const q, priority_node* const tree) {
    if (q->rootlist) {
      priority_node* l = q->rootlist->left;
      l->right = tree;
      q->rootlist->left = tree;
      tree->left = l;
      tree->right = q->rootlist;
      if (q->compare_function(tree->priority, q->min->priority) < 0)
	q->min = tree;
    } else {
      q->rootlist = tree;
      q->min = tree;
    }
    return q;
}

// Meld two queues into one new queue. We take the first queue and the rootnode of the second queue. // TODO: Expose in API
static
priority_queue* meld_queue(priority_queue* q1, priority_node* q2, unsigned int length_q2) {
  if (!q1->rootlist) {
    q1->rootlist = q2;
    q1->min = q2;
    q1->length = length_q2;
  } else {
    priority_node* r1 = q1->rootlist->left;
    priority_node* r2 = q2->left;  

    q1->rootlist->left = r2;
    r2->right = q1->rootlist;

    q2->left = r1;
    r1->right = q2;

    q1->length = q1->length + length_q2;

    if (q1->compare_function(q2->priority, q1->min->priority) < 0)
      q1->min = q2;
  }

  return q1;
}

// Add an object and a priority to a priority queue. Returns a pointer to a
// priority_node structure, which can be used in delete_node and priority_queue_change_priority
// operations.
priority_node* priority_queue_add_node(priority_queue* q, VALUE object, VALUE priority) {
  priority_node* result = create_priority_node(object, priority);
  insert_tree(q, result);
  q->length++;
  return result;
}

// Does not change length
static 
priority_node* delete_first(priority_queue* const q) {  
  if (q->rootlist) {
    priority_node* result = q->rootlist;
    if (result == result->right)
      q->rootlist = NULL;
    else {
      q->rootlist = result->right;
      result->left->right = result->right;
      result->right->left = result->left;
      result->right = result;
      result->left = result;
    }
    return result;
  } else {
    return NULL;
  }
}

static
void assert_pointers_correct(priority_node* n) {
  if (!n) return;

  priority_node *n1 = n->right;
  while(n != n1) {
    if (n1->child && (n1 != n1->child->parent)) 
      printf("Eltern-Kind Zeiger inkorrekt: %p\n", n);

    if (n1 != n1->right->left)
      printf("Rechts-links inkorrekt: %p\n", n);

    if (n1 != n1->left->right)
      printf("links-Rechts inkorrekt: %p\n", n);

    assert_pointers_correct(n1->child);
    n1 = n1->right;
  }
}

// Consolidate a queue in amortized O(log n)
static 
void consolidate_queue(priority_queue* const q) {
  unsigned int array_size = 2 * log(q->length) / log(2) + 1;
  priority_node* tree_by_degree[array_size];
  unsigned int i;
  for (i=0; i<array_size; i++)
    tree_by_degree[i] = NULL;

  priority_node* n = NULL;
  while (((n = delete_first(q)))) {
    priority_node* n1 = NULL;
    while (((n1 = tree_by_degree[n->degree]))) {
      tree_by_degree[n->degree] = NULL;
      n = link_nodes(q, n, n1);
    }
    tree_by_degree[n->degree] = n;
  }

  // Find minimum value in O(log n) 
  q->rootlist = NULL;
  q->min = NULL;
  for (i=0; i<array_size; i++) {    
    if (tree_by_degree[i] != NULL) {
      insert_tree(q, tree_by_degree[i]);
    }
  }
}

// Delete and extract priority_node with minimal priority O(log n)
priority_node* priority_queue_delete_min(priority_queue* q) {
  if (!q->rootlist) return NULL;
  priority_node* min = q->min;

  if (q->length == 1){ // length == 1
    q->rootlist = NULL;
    q->min = NULL;
    q->length = 0;
  } else {
    unsigned int length = q->length;
    // Abtrennen.
    if (q->min == q->rootlist) {
      if (q->min == q->min->right) {
	q->rootlist = NULL;
	q->min = NULL;
      } else {
	q->rootlist = q->min->right;
      }
    }
    min->left->right = min->right;
    min->right->left = min->left;
    min->left = min;
    min->right = min;
    if (min->child) {
      // Kinder und Eltern trennen, Markierung aufheben, und kleinstes Kind bestimmen.
      priority_node* n = min->child;
      do {
	n->parent = NULL;
	n->mark = false;
	n = n->right;
      } while (n!=min->child);

      // Kinder einfügen
      if (q->rootlist) {
	priority_node* const l1 = q->rootlist->left;
	priority_node* const l2 = n->left;

	l1->right = n;
	n->left = l1;
	l2->right = q->rootlist;
	q->rootlist->left = l2;
      } else {
	q->rootlist = n;
      }
    }

    // Größe anpassen
    q->length = length-1;

    // Wieder aufhübschen
    consolidate_queue(q);
  }

  return min;
}

static
  priority_queue* cut_node(priority_queue* q, priority_node* n) {
    if (!n->parent)
      return q;  
    n->parent->degree--;
    if (n->parent->child == n) {
      if (n->right == n)
	n->parent->child = NULL;
      else
	n->parent->child = n->right;  
    }
    n->parent = NULL;
    n->right->left = n->left;
    n->left->right = n->right;

    n->right = q->rootlist;
    n->left  = q->rootlist->left;
    q->rootlist->left->right = n;
    q->rootlist->left = n;
    q->rootlist = n;

    n->mark = false;

    return q;
  }

// change the priority of a priority_node and restructure the queue
// Does not free the priority node
priority_queue* priority_queue_delete(priority_queue* q, priority_node* n) {
  if (n->child) {
    priority_node* c = n->child;
    priority_node* e = n->child;
    do {
      priority_node* r = c->right;
      cut_node(q, c);
      c = r;
    } while (c != e);
  }
  if (n->parent)
    cut_node(q, n);
  if (n == n->right) {
    q->min = NULL;
    q->rootlist = NULL;
  } else {
    if (q->rootlist == n)
      q->rootlist = n->right;
    if (q->min == n) {
      priority_node* n1 = n->right;
      q->min = n1;
      do {
	if (q->compare_function(n1->priority, q->min->priority) <= 0) 
	  q->min = n1;
	n1 = n1->right;
      } while(n1 != n);
    }
    n->right->left = n->left;
    n->left->right = n->right;
    n->left = n;
    n->right = n;
  }
  q->length -= 1;
  return q;
}

// change the priority of a priority_node and restructure the queue
priority_queue* priority_queue_change_priority(priority_queue* q, priority_node* n, VALUE priority) {
  if (q->compare_function(n->priority, priority) <= 0) { // Priority was increased. Remove the node and reinsert.
    priority_queue_delete(q, n);
    n->priority = priority;
    meld_queue(q, n, 1);
    return q;
  }    
  n->priority = priority;
  if (q->compare_function(n->priority, q->min->priority) < 0)
    q->min = n;
  if (!(n->parent) || (q->compare_function(n->parent->priority, n->priority) <= 0)) // Already in rootlist or bigger than parent
    return q;
  do { // Cascading Cuts
    priority_node* p = n->parent;
    cut_node(q, n);
    n = p;
  } while (n->mark && n->parent);
  if (n->parent)
    n->mark = true;
  return q;
}

// Get the priority_node with the minimum priority from a queue
priority_node* priority_queue_min(priority_queue *q) {
  return q->min;
}

_Bool priority_queue_empty(priority_queue *q) {
  return q->min == NULL;
}

// change the priority of a priority_node and restructure the queue
priority_queue* priority_queue_each_node(priority_queue* q, priority_node* n, 
    void (*each)(priority_queue* q_, priority_node* n_, void* args), void* arguments) {
  priority_node* end = n;
  do {
    priority_node* next = n->right;
    (*each)(q, n, arguments);
    if (n->child)
      priority_queue_each_node(q, n->child, each, arguments);
    n = n->right;
    if (n != next)
      break;
  } while (n != end);
  return q;
}

priority_queue* priority_queue_each(priority_queue* q,  
    void (*each)(priority_queue* q, priority_node* n, void* args), void* arguments) {
  if (q->rootlist)
    priority_queue_each_node(q, q->rootlist, each, arguments);
  return q;
}
////////////////////////////////////////////////////////////////////////////////
// Define the ruby classes
////////////////////////////////////////////////////////////////////////////////

static int id_compare_operator;
static int id_format;
static int id_display;

priority_queue* get_pq_from_value(VALUE self) {
  priority_queue *q; 
  Data_Get_Struct(self, priority_queue, q);
  return q;
}

static
int priority_compare_function(VALUE a, VALUE b) {
  return FIX2INT(rb_funcall((VALUE) a, id_compare_operator, 1, (VALUE) b));
}

static
void pq_free(void *p) {
  priority_queue_free(p);
}

static
void pq_mark_recursive(priority_node* n) {
  if (!n) return;
  rb_gc_mark((VALUE) n->object);
  rb_gc_mark((VALUE) n->priority);
  priority_node* n1 = n->child;
  if (!n1) return;
  do {
    pq_mark_recursive(n1);
    n1 = n1->right;
  } while (n1 != n->child);
}

static
void pq_mark(void *q) {  
  priority_node* n1 = ((priority_queue*) q)->rootlist;
  if (!n1)
    return;
  priority_node* n2 = n1;
  do {
    pq_mark_recursive(n1);
    n1 = n1->right;
  } while (n1 != n2);
}

static 
VALUE pq_alloc(VALUE klass) {
  priority_queue *q;
  VALUE object;

  q = create_priority_queue(&priority_compare_function);

  object = Data_Wrap_Struct(klass, pq_mark, pq_free, q);

  return object;
}

/*
 * Create a new, empty PriorityQueue
 */
static
VALUE pq_init(VALUE self) {
  rb_iv_set(self, "@__node_by_object__", rb_hash_new());

  return self;
}

/*
 * Add an object to the queue.
 */
static
VALUE pq_push(VALUE self, VALUE object, VALUE priority) {
  VALUE hash = rb_iv_get(self, "@__node_by_object__");

  priority_queue* q = get_pq_from_value(self);

  priority_node* n = priority_queue_add_node(q, object, priority);

  rb_hash_aset(hash, object, ULONG2NUM((unsigned long) n)); // TODO: This is hackish, maybe its better to also wrap the nodes.

  return self;
}

/* call-seq:
 *     min -> [object, priority]
 *     
 * Return the pair [object, priority] with minimal priority or nil when the
 * queue is empty.
 *
 *     q = PriorityQueue.new
 *     q["a"] = 10
 *     q["b"] = 20
 *     q.min          #=> ["a", 10]
 *     q.delete_min   #=> ["a", 10]
 *     q.min          #=> ["b", 20]
 *     q.delete_min   #=> ["b", 20]
 *     q.min          #=> nil
 */
static
VALUE pq_min(VALUE self) {
  priority_queue* q = get_pq_from_value(self);

  priority_node* n = priority_queue_min(q);
  if (n)
    return rb_ary_new3(2, n->object, n->priority);
  else
    return Qnil;
}

/* call-seq:
 *     min_key -> object
 *     
 * Return the key that has the minimal priority or nil when the queue is empty.
 *
 *     q = PriorityQueue.new
 *     q["a"] = 10
 *     q["b"] = 20
 *     q.min_key      #=> "a"
 *     q.delete_min   #=> ["a", 10]
 *     q.min_key      #=> "b"
 *     q.delete_min   #=> ["b", 20]
 *     q.min_key      #=> nil
 */
static
VALUE pq_min_key(VALUE self) {
  priority_queue* q = get_pq_from_value(self);

  priority_node* n = priority_queue_min(q);
  if (n)
    return n->object;
  else
    return Qnil;
}

/* call-seq:
 *     min_priority -> priority
 *
 * Return the minimal priority or nil when the queue is empty.
 *
 *     q = PriorityQueue.new
 *     q["a"] = 10
 *     q["b"] = 20
 *     q.min_priority #=> 10
 *     q.delete_min   #=> ["a", 10]
 *     q.min_priority #=> 20
 *     q.delete_min   #=> ["b", 20]
 *     q.min_priority #=> nil
 */
static
VALUE pq_min_priority(VALUE self) {
  priority_queue* q = get_pq_from_value(self);

  priority_node* n = priority_queue_min(q);
  if (n)
    return n->priority;
  else
    return Qnil;
}

/* call-seq:
 *    delete_min -> [key, priority]
 * 
 * Delete key with minimal priority and return [key, priority]
 *
 *    q = PriorityQueue.new
 *    q["a"] = 1
 *    q["b"] = 0
 *    q.delete_min #=> ["b", 0]
 *    q.delete_min #=> ["a", 1]
 *    q.delete_min #=> nil
 */
static
VALUE pq_delete_min(VALUE self) {
  VALUE hash = rb_iv_get(self, "@__node_by_object__");
  priority_queue* q = get_pq_from_value(self);

  priority_node* n = priority_queue_delete_min(q);

  if (n) {
    rb_hash_delete(hash, n->object); // TODO: Maybe we have a problem here with garbage collection of n->object?
    return rb_ary_new3(2, n->object, n->priority);  
  } else {
    return Qnil;
  }
}

/* call-seq:
 *    delete_min_return_key -> key
 * 
 * Delete key with minimal priority and return the key
 *
 *    q = PriorityQueue.new
 *    q["a"] = 1
 *    q["b"] = 0
 *    q.delete_min_return_key #=> "b"
 *    q.delete_min_return_key #=> "a"
 *    q.delete_min_return_key #=> nil
 */
static
VALUE pq_delete_min_return_key(VALUE self) {
  VALUE hash = rb_iv_get(self, "@__node_by_object__");
  priority_queue* q = get_pq_from_value(self);

  priority_node* n = priority_queue_delete_min(q);

  if (n) {
    rb_hash_delete(hash, n->object); // TODO: Maybe we have a problem here with garbage collection of n->object?
    return n->object;  
  } else {
    return Qnil;
  }
}

/*
 * call-seq:
 *   delete_min_return_priority -> priority
 *
 * Delete key with minimal priority and return the priority value
 *
 *    q = PriorityQueue.new
 *    q["a"] = 1
 *    q["b"] = 0
 *    q.delete_min_return_priority #=> 0
 *    q.delete_min_return_priority #=> 1
 *    q.delete_min_return_priority #=> nil
 */
static
VALUE pq_delete_min_return_priority(VALUE self) {
  VALUE hash = rb_iv_get(self, "@__node_by_object__");
  priority_queue* q = get_pq_from_value(self);

  priority_node* n = priority_queue_delete_min(q);

  if (n) {
    rb_hash_delete(hash, n->object); // TODO: Maybe we have a problem here with garbage collection of n->object?
    return n->priority;  
  } else {
    return Qnil;
  }
}

/*
 * call-seq:
 *     [key] = priority
 *     change_priority(key, priority)
 *     push(key, priority)
 *
 * Set the priority of a key.
 *
 *     q = PriorityQueue.new
 *     q["car"] = 50
 *     q["train"] = 50
 *     q["bike"] = 10
 *     q.min #=> ["bike", 10]
 *     q["car"] = 0
 *     q.min #=> ["car", 0]
 */
static
VALUE pq_change_priority(VALUE self, VALUE object, VALUE priority) {
  VALUE hash = rb_iv_get(self, "@__node_by_object__");
  priority_queue* q = get_pq_from_value(self);

  VALUE node = rb_hash_aref(hash, object);
  if (NIL_P(node)) {
    pq_push(self, object, priority);
  } else {
    priority_queue_change_priority(q, (priority_node*) NUM2ULONG(node), priority);
  }

  return self;
}

/*
 * call-seq:
 *     [key] -> priority
 *
 * Return the priority of a key or nil if the key is not in the queue.
 *
 *     q = PriorityQueue.new
 *     (0..10).each do | i | q[i.to_s] = i end
 *     q["5"] #=> 5
 *     q[5] #=> nil
 */
static
VALUE pq_get_priority(VALUE self, VALUE object) {
  VALUE hash = rb_iv_get(self, "@__node_by_object__");

  VALUE node_pointer = rb_hash_aref(hash, object);
  
  if (NIL_P(node_pointer))
    return Qnil;
  else
    return (VALUE) (((priority_node*) NUM2ULONG(node_pointer))->priority);
}

/*
 * call-seq:
 *     has_key? key -> boolean
 *     
 * Return false if the key is not in the queue, true otherwise.
 *
 *     q = PriorityQueue.new
 *     (0..10).each do | i | q[i.to_s] = i end
 *     q.has_key("5") #=> true 
 *     q.has_key(5)   #=> false
 */
static
VALUE pq_has_key(VALUE self, VALUE object) {
  VALUE hash = rb_iv_get(self, "@__node_by_object__");

  VALUE node_pointer = rb_hash_aref(hash, object);
  
  return NIL_P(node_pointer) ? Qfalse : Qtrue;
}
/* call-seq:
 *     length -> Fixnum
 * 
 * Returns the number of elements of the queue.
 * 
 *     q = PriorityQueue.new
 *     q.length #=> 0
 *     q[0] = 1
 *     q.length #=> 1
 */
static
VALUE pq_length(VALUE self) {
  priority_queue* q = get_pq_from_value(self);

  return INT2NUM(q->length);
}

/* call-seq:
 *    delete(key) -> [key, priority]
 *    delete(key) -> nil
 * 
 * Delete a key from the priority queue. Returns nil when the key was not in
 * the queue and [key, priority] otherwise.
 * 
 *     q = PriorityQueue.new
 *     (0..10).each do | i | q[i.to_s] = i end
 *     q.delete(5)                               #=> ["5", 5]
 *     q.delete(5)                               #=> nil
 */
static
VALUE pq_delete(VALUE self, VALUE object) {
  priority_queue* q = get_pq_from_value(self);

  VALUE hash = rb_iv_get(self, "@__node_by_object__");

  VALUE node_pointer = rb_hash_aref(hash, object);  
  
  if (NIL_P(node_pointer))
    return Qnil;
  else {
    priority_node* n = (priority_node*) NUM2ULONG(node_pointer);
    VALUE object = n->object;
    VALUE priority = n->priority;
    priority_queue_delete(q, n);
    rb_hash_delete(hash, object);
    priority_node_free(n);
    return rb_ary_new3(2, object, priority);
  }
}


// Dot a single node of a priority queue. Called by pq_to_dot to do the inner work.
// (I'm not proud of this function ;-( )
static
void pq_node2dot(VALUE result_string, priority_node* n, unsigned int level) {
  if (n == NULL) return;  
  unsigned int i;
  for (i=0; i<level; i++) rb_str_cat2(result_string, "  ");  
  if (n->mark)
    rb_str_concat(result_string,
	rb_funcall(Qnil, id_format, 4, rb_str_new2("NODE%i [label=\"%s (%s)\"];\n"), 
	  ULONG2NUM((unsigned long) n), n->object, n->priority));
  else
    rb_str_concat(result_string,
	rb_funcall(Qnil, id_format, 4, rb_str_new2("NODE%i [label=\"%s (%s)\",shape=box];\n"), 
	  ULONG2NUM((unsigned long) n), n->object, n->priority));
  if (n->child != NULL) {
    priority_node* n1 = n->child;
    do {
      pq_node2dot(result_string, n1, level + 1);
      for (i=0; i<level; i++) rb_str_cat2(result_string, "  ");  
      rb_str_concat(result_string,
	  rb_funcall(Qnil, id_format, 4, rb_str_new2("NODE%i -> NODE%i;\n"), 
	    ULONG2NUM((unsigned long) n), ULONG2NUM((unsigned long) n1)));
      n1 = n1->right;
    } while(n1 != n->child);
  }
}

/* 
 * Print a priority queue as a dot-graph. The output can be fed to dot from the
 * vizgraph suite to create a tree depicting the internal datastructure.
 * 
 * (I'm not proud of this function ;-( )
 */
static
VALUE pq_to_dot(VALUE self) {
  priority_queue* q = get_pq_from_value(self);

  VALUE result_string = rb_str_new2("digraph fibonacci_heap {\n");
  if (q->rootlist) {
    priority_node* n1 = q->rootlist;
    do {    
      pq_node2dot(result_string, n1, 1);
      n1 = n1->right;
    } while(n1 != q->rootlist);
  }
  rb_str_cat2(result_string, "}\n");
  return result_string;
}

/*
 * Returns true if the array is empty, false otherwise.
 */
static
VALUE pq_empty(VALUE self) {
  priority_queue* q = get_pq_from_value(self);
  return priority_queue_empty(q) ? Qtrue : Qfalse;
}

static
void pq_each_helper(priority_queue *q, priority_node *n, void *args) {
  rb_yield(rb_ary_new3(2, n->object, n->priority));
};

/*
 * Call the given block with each [key, priority] pair in the queue
 *
 * Beware: Changing the queue in the block may lead to unwanted behaviour and
 * even infinite loops.
 */
static
VALUE pq_each(VALUE self) {
  priority_queue* q = get_pq_from_value(self);
  priority_queue_each(q, &pq_each_helper, NULL);
  return self;
}

static
VALUE pq_insert_node(VALUE node, VALUE queue) {
  return pq_push(queue, rb_ary_entry(node, 0), rb_ary_entry(node, 1));
}

static
VALUE pq_initialize_copy(VALUE copy, VALUE orig) {
  if (copy == orig)
    return copy;

  rb_iterate(rb_each, orig, pq_insert_node, copy);
  
  return copy;
}

/*
 * Returns a string representation of the priority queue.
 */
static
VALUE pq_inspect(VALUE self) {  
  VALUE result = rb_str_new2("<PriorityQueue: ");
  rb_str_concat(result,
      rb_funcall(rb_funcall(self, rb_intern("to_a"), 0),
	rb_intern("inspect"), 0));
  rb_str_concat(result, rb_str_new2(">"));
  return result;
}

VALUE cPriorityQueue;

/* 
 * A Priority Queue implementation
 *
 * A priority queue is a queue, where each element (the key) has an assigned
 * priority.  It is possible to efficently decrease priorities and to
 * efficently look up and remove the key with the smallest priority.
 *
 * This datastructure is used in different algorithms. The standard algorithm
 * used to introduce priority queues is dijkstra's shortest path algorithm.
 *
 * The priority queue includes the Enumerable module.
 */
void Init_CPriorityQueue() {
  id_compare_operator = rb_intern("<=>");
  id_format = rb_intern("format");
  id_display = rb_intern("display");

  cPriorityQueue = rb_define_class("CPriorityQueue", rb_cObject);

  rb_define_alloc_func(cPriorityQueue, pq_alloc);
  rb_define_method(cPriorityQueue, "initialize", pq_init, 0);
  rb_define_method(cPriorityQueue, "initialize_copy", pq_initialize_copy, 1);
  rb_define_method(cPriorityQueue, "min", pq_min, 0);
  rb_define_method(cPriorityQueue, "min_key", pq_min_key, 0);
  rb_define_method(cPriorityQueue, "min_priority", pq_min_priority, 0);
  rb_define_method(cPriorityQueue, "delete_min", pq_delete_min, 0);
  rb_define_method(cPriorityQueue, "delete_min_return_key", pq_delete_min_return_key, 0);
  rb_define_method(cPriorityQueue, "delete_min_return_priority", pq_delete_min_return_priority, 0);
  rb_define_method(cPriorityQueue, "push", pq_change_priority, 2);
  rb_define_method(cPriorityQueue, "change_priority", pq_change_priority, 2);
  rb_define_method(cPriorityQueue, "[]=", pq_change_priority, 2);
  rb_define_method(cPriorityQueue, "priority", pq_get_priority, 1);
  rb_define_method(cPriorityQueue, "[]", pq_get_priority, 1);
  rb_define_method(cPriorityQueue, "has_key?", pq_has_key, 1);
  rb_define_method(cPriorityQueue, "length", pq_length, 0);
  rb_define_method(cPriorityQueue, "to_dot", pq_to_dot, 0);
  rb_define_method(cPriorityQueue, "empty?", pq_empty, 0);
  rb_define_method(cPriorityQueue, "delete", pq_delete, 1);
  rb_define_method(cPriorityQueue, "inspect", pq_inspect, 0);
  rb_define_method(cPriorityQueue, "each", pq_each, 0);
  rb_include_module(cPriorityQueue, rb_eval_string("Enumerable"));
}
