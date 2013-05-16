#include "ruby.h"

#define RED 1
#define BLACK 0

#define FALSE 0
#define TRUE 1

typedef struct struct_rbtree_node {
	int color;
	VALUE key;
	VALUE value;
	struct struct_rbtree_node *left;
	struct struct_rbtree_node *right;
	unsigned int height;
	unsigned int num_nodes;
} rbtree_node;

typedef struct {
	unsigned int black_height;
	int (*compare_function)(VALUE key1, VALUE key2);
	rbtree_node *root;
} rbtree;

typedef struct struct_ll_node {
	rbtree_node *node;
	struct struct_ll_node *next;
} ll_node;

static void recursively_free_nodes(rbtree_node *node) {
	if(node) {
		recursively_free_nodes(node->left);
		recursively_free_nodes(node->right);
		xfree(node);
	}
	return;
}

static rbtree* get_tree_from_self(VALUE self) {
	rbtree *tree;
	Data_Get_Struct(self, rbtree, tree);
	return tree;
}

static int isred(rbtree_node *node) {
	if(!node) { return FALSE; }
	
	if(node->color == RED) { return TRUE; }
	else return FALSE;
}

static void colorflip(rbtree_node *node) {
	node->color = !node->color;
	node->left->color = !node->left->color;
	node->right->color = !node->right->color;
}

static int size(rbtree_node *h) {
	if(!h) {
		return 0;
	}
	else return h->num_nodes;
}

static int height(rbtree_node *h) {
	if(!h) { return 0; }
	else return h->height;
}

static rbtree_node* set_num_nodes(rbtree_node *h) {
	h->num_nodes = size(h->left) + size(h->right) + 1;
	if ( height(h->left) > height(h->right) ) {
		h->height = height(h->left) +1;
	}
	else {
		h->height = height(h->right) +1;
	}
	return h;
}

static rbtree_node* rotate_left(rbtree_node *h) {
	rbtree_node *x = h->right;
	h->right = x->left;
	x->left = set_num_nodes(h);
	x->color = x->left->color;
	x->left->color = RED;
	return set_num_nodes(x);	
}

static rbtree_node* rotate_right(rbtree_node *h) {
	rbtree_node *x = h->left;
	h->left = x->right;
	x->right = set_num_nodes(h);
	x->color = x->right->color;
	x->right->color = RED;
	return set_num_nodes(x);	
}

static rbtree_node* move_red_left(rbtree_node *h) {
	colorflip(h);
	if ( isred(h->right->left) ) {
		h->right = rotate_right(h->right);
		h = rotate_left(h);
		colorflip(h);
	}
	return h;
}

static rbtree_node* move_red_right(rbtree_node *h) {
	colorflip(h);
	if ( isred(h->left->left) ) {
		h = rotate_right(h);
		colorflip(h);
	}
	return h;
}

static rbtree_node* fixup(rbtree_node *h) {
	if ( isred(h->right) )
		h = rotate_left(h);
	
	if ( isred(h->left) && isred(h->left->left) )
		h = rotate_right(h);
	
	if ( isred(h->left) && isred(h->right) )
		colorflip(h);
		
	return set_num_nodes(h);
}

static rbtree* create_rbtree(int (*compare_function)(VALUE, VALUE)) {
	rbtree *tree = ALLOC(rbtree);
	tree->black_height = 0;
	tree->compare_function = compare_function;
	tree->root = NULL;
	return tree;
}

static rbtree_node* insert(rbtree *tree, rbtree_node *node, VALUE key, VALUE value) {
	int cmp;
	
	// This slot is empty, so we insert our new node
	if(!node) {
		rbtree_node *new_node = ALLOC(rbtree_node);
		new_node->key		= key;
		new_node->value		= value;
		new_node->color		= RED;
		new_node->height	= 1;
		new_node->num_nodes = 1;
		new_node->left		= NULL;
		new_node->right		= NULL;
		return new_node;
	}
	
	// Insert left or right, recursively
	cmp = tree->compare_function(key, node->key);
	if		(cmp == 0)	{ node->value = value; }
	else if (cmp == -1) { node->left	= insert(tree, node->left, key, value); }
	else				{ node->right = insert(tree, node->right, key, value); }
	
	// Fix our tree to keep left-lean
	if (isred(node->right)) { node = rotate_left(node); }
	if (isred(node->left) && isred(node->left->left)) { node = rotate_right(node); }
	if ( isred(node->left) && isred(node->right) ) {
		colorflip(node);
	}
	return set_num_nodes(node);
}

static VALUE get(rbtree *tree, rbtree_node *node, VALUE key) {
	int cmp;
	if (!node) {
		return Qnil;
	}
	
	cmp = tree->compare_function(key, node->key);
	if		(cmp == 0)	{ return node->value; }
	else if (cmp == -1) { return get(tree, node->left, key); }
	else				{ return get(tree, node->right, key); }
	
}

static VALUE min_key(rbtree_node *node) {
	while (node->left)
		node = node->left;
		
	return node->key;
}

static VALUE max_key(rbtree_node *node) {
	while (node->right)
		node = node->right;
	
	return node->key;
}

static rbtree_node* delete_min(rbtree_node *h, VALUE *deleted_value) {
	if ( !h->left ) {
		if(deleted_value)
			*deleted_value = h->value;
		xfree(h);
		return NULL;
	}
	
	if ( !isred(h->left) && !isred(h->left->left) )
		h = move_red_left(h);

	h->left = delete_min(h->left, deleted_value);

	return fixup(h);
}

static rbtree_node* delete_max(rbtree_node *h, VALUE *deleted_value) {
	if ( isred(h->left) )
		h = rotate_right(h);

	if ( !h->right ) {
		*deleted_value = h->value;
		xfree(h);
		return NULL;
	}

	if ( !isred(h->right) && !isred(h->right->left) )
		h = move_red_right(h);

	h->right = delete_max(h->right, deleted_value);

	return fixup(h);
}

static rbtree_node* delete(rbtree *tree, rbtree_node *node, VALUE key, VALUE *deleted_value) {
	int cmp;
	VALUE minimum_key;
	cmp = tree->compare_function(key, node->key);
	if (cmp == -1) {
		if ( !isred(node->left) && !isred(node->left->left) )
			node = move_red_left(node);
		
		node->left = delete(tree, node->left, key, deleted_value);
	}
	else {
		if ( isred(node->left) )
			node = rotate_right(node);
		
		cmp = tree->compare_function(key, node->key);
		if ( (cmp == 0) && !node->right ) {
			*deleted_value = node->value;
			xfree(node);
			return NULL;
		}

		if ( !isred(node->right) && !isred(node->right->left) )
			node = move_red_right(node);
		
		cmp = tree->compare_function(key, node->key);
		if (cmp == 0) {
			*deleted_value = node->value;
			minimum_key = min_key(node->right);
			node->value = get(tree, node->right, minimum_key);
			node->key = minimum_key;
			node->right = delete_min(node->right, NULL);
		}
		else {
			node->right = delete(tree, node->right, key, deleted_value);
		}
	}
	return fixup(node);
}

static rbtree* rbtree_each_node(rbtree *tree, rbtree_node *node, void (*each)(rbtree *tree_, rbtree_node *node_, void* args), void* arguments) {
	if (!node)
		return NULL;
	
		if (node->left)
			rbtree_each_node(tree, node->left, each, arguments);
	(*each)(tree, node, arguments);
		if (node->right)
			rbtree_each_node(tree, node->right, each, arguments);
	return tree;
}

static rbtree* rbt_each(rbtree *tree, void (*each)(rbtree *tree, rbtree_node *node, void *args), void* arguments) {
	if (tree->root)
			rbtree_each_node(tree, tree->root, each, arguments);
		return tree;
}

// Methods to be called in Ruby

static VALUE id_compare_operator;

static int rbtree_compare_function(VALUE a, VALUE b) {
	if (a == b) return 0;
	if (FIXNUM_P(a) && FIXNUM_P(b)) {
		long x = FIX2LONG(a), y = FIX2LONG(b);
		if (x == y) return 0;
		if (x > y) return 1;
		return -1;
	}
	if (TYPE(a) == T_STRING && rb_obj_is_kind_of(a, rb_cString) &&
            TYPE(b) == T_STRING && rb_obj_is_kind_of(b, rb_cString)) {
		return rb_str_cmp(a, b);
	}
	return FIX2INT(rb_funcall((VALUE) a, id_compare_operator, 1, (VALUE) b));
}

static VALUE rbtree_init(VALUE self)
{
	return self;
}

static void rbtree_mark(void *ptr) {
	ll_node *current, *new, *last, *old;
	if (ptr) {
		rbtree *tree = ptr;
		
		if (tree->root) {
			current = ALLOC(ll_node);
			last = current;
			current->node = tree->root;
			current->next = NULL;

			while(current) {
				rb_gc_mark(current->node->key);
				rb_gc_mark(current->node->value);
				if (current->node->left) {
					new = ALLOC(ll_node);
					new->node = current->node->left;
					new->next = NULL;
					last->next = new;
					last = new;
				} 
				if (current->node->right) {
					new = ALLOC(ll_node);
					new->node = current->node->right;
					new->next = NULL;
					last->next = new;
					last = new;
				}
				old = current;
				current = current->next;
				xfree(old);
			}
		}
	}
}

static void rbtree_free(void *ptr) {
	if (ptr) {
		rbtree *tree = ptr;
		recursively_free_nodes(tree->root);
		xfree(tree);
	}
}

static VALUE rbtree_alloc(VALUE klass) {
	rbtree *tree = create_rbtree(&rbtree_compare_function);
	return Data_Wrap_Struct(klass, rbtree_mark, rbtree_free, tree);
}

static VALUE rbtree_push(VALUE self, VALUE key, VALUE value) {
	rbtree *tree = get_tree_from_self(self);
	tree->root = insert(tree, tree->root, key, value);
	return value;
}

static VALUE rbtree_get(VALUE self, VALUE key) {
	rbtree *tree = get_tree_from_self(self);
	return get(tree, tree->root, key);
}

static VALUE rbtree_size(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	return INT2NUM(size(tree->root));
}

static VALUE rbtree_is_empty(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	return (tree->root ? Qfalse : Qtrue);
}

static VALUE rbtree_height(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	return INT2NUM(height(tree->root));
}

static VALUE rbtree_has_key(VALUE self, VALUE key) {
	rbtree *tree = get_tree_from_self(self);
	if(!tree->root) { return Qfalse; }
	if(get(tree, tree->root, key) == Qnil)
		return Qfalse;
	
	return Qtrue;
}

static VALUE rbtree_min_key(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	return min_key(tree->root);
}

static VALUE rbtree_max_key(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	return max_key(tree->root);
}

static VALUE rbtree_delete(VALUE self, VALUE key) {
	VALUE deleted_value;
	rbtree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	tree->root = delete(tree, tree->root, key, &deleted_value);
	if(tree->root)
		tree->root->color = BLACK;
	
	if(deleted_value) {
		return deleted_value;
	}
		
	return Qnil;
}

static VALUE rbtree_delete_min(VALUE self) {
	VALUE deleted_value;
	rbtree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	tree->root = delete_min(tree->root, &deleted_value);
	if(tree->root)
		tree->root->color = BLACK;
	
	if(deleted_value) {
		return deleted_value;
	}
		
	return Qnil;
}

static VALUE rbtree_delete_max(VALUE self) {
	VALUE deleted_value;
	rbtree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	tree->root = delete_max(tree->root, &deleted_value);
	if(tree->root)
		tree->root->color = BLACK;
	
	if(deleted_value) {
		return deleted_value;
	}
		
	return Qnil;
}

static void rbtree_each_helper(rbtree *tree, rbtree_node *node, void *args) {
	rb_yield(rb_ary_new3(2, node->key, node->value));
};

static VALUE rbtree_each(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	rbt_each(tree, &rbtree_each_helper, NULL);
	return self;
}

static VALUE cRBTree;
static VALUE mContainers;

void Init_CRBTreeMap() {
	id_compare_operator = rb_intern("<=>");
	
	mContainers = rb_define_module("Containers");
	cRBTree = rb_define_class_under(mContainers, "CRBTreeMap", rb_cObject);
	rb_define_alloc_func(cRBTree, rbtree_alloc);
	rb_define_method(cRBTree, "initialize", rbtree_init, 0);
	rb_define_method(cRBTree, "push", rbtree_push, 2);
	rb_define_alias(cRBTree, "[]=", "push");
	rb_define_method(cRBTree, "size", rbtree_size, 0);
	rb_define_method(cRBTree, "empty?", rbtree_is_empty, 0);
	rb_define_method(cRBTree, "height", rbtree_height, 0);
	rb_define_method(cRBTree, "min_key", rbtree_min_key, 0);
	rb_define_method(cRBTree, "max_key", rbtree_max_key, 0);
	rb_define_method(cRBTree, "delete_min", rbtree_delete_min, 0);
	rb_define_method(cRBTree, "delete_max", rbtree_delete_max, 0);
	rb_define_method(cRBTree, "each", rbtree_each, 0);
	rb_define_method(cRBTree, "get", rbtree_get, 1);
	rb_define_alias(cRBTree, "[]", "get");
	rb_define_method(cRBTree, "has_key?", rbtree_has_key, 1);
	rb_define_method(cRBTree, "delete", rbtree_delete, 1);
	rb_include_module(cRBTree, rb_eval_string("Enumerable"));
}
