#include "ruby.h"

#define node_size(x) (((x)==NULL) ? 0 : ((x)->size))

/* 	Using http://www.link.cs.cmu.edu/link/ftp-site/splaying/top-down-size-splay.c as reference,
	written by D. Sleator <sleator@cs.cmu.edu>, January 1994.
*/

typedef struct struct_splaytree_node {
	VALUE key;
	VALUE value;
	int size;
	struct struct_splaytree_node *left;
	struct struct_splaytree_node *right;
} splaytree_node;

typedef struct {
	int (*compare_function)(VALUE key1, VALUE key2);
	splaytree_node *root;
} splaytree;

typedef struct struct_ll_node {
	splaytree_node *node;
	struct struct_ll_node *next;
} ll_node;

static void recursively_free_nodes(splaytree_node *node) {
	if(node) {
		recursively_free_nodes(node->left);
		recursively_free_nodes(node->right);
		xfree(node);
	}
	return;
}

static splaytree* get_tree_from_self(VALUE self) {
	splaytree *tree;
	Data_Get_Struct(self, splaytree, tree);
	return tree;
}

static splaytree_node* splay(splaytree *tree, splaytree_node *n, VALUE key) {
	int cmp, cmp2, root_size, l_size, r_size;
	splaytree_node N;
	splaytree_node *l, *r, *y;
	
	if (!n) return n;
	
	N.left = N.right = NULL;
	l = r = &N;
	root_size = node_size(n);
	l_size = r_size = 0;
	
	while(1) {
		cmp = tree->compare_function(key, n->key);
		if (cmp == -1) {
			if (!n->left) break;
			cmp2 = tree->compare_function(key, n->left->key);
			if (cmp2 == -1) {
				y = n->left;
				n->left = y->right;
				y->right = n;
				n->size = node_size(n->left) + node_size(n->right) + 1;
				n = y;
          		if (!n->left) break;
			}
			r->left = n;
			r = n;
			n = n->left;
			r_size += 1 + node_size(r->right);
		} else if (cmp == 1) {
			if (!n->right) break;
			cmp2 = tree->compare_function(key, n->right->key);
			if (cmp2 == 1) {
				y = n->right;
				n->right = y->left;
				y->left = n;
				n->size = node_size(n->left) + node_size(n->right) + 1;
				n = y;
          		if (!n->right) break;
			}
			l->right = n;
			l = n;
			n = n->right;
			l_size += 1 + node_size(l->left);
		} else {
			break;
		}
	}
	
	l_size += node_size(n->left);
    r_size += node_size(n->right);
    n->size = l_size + r_size + 1;
    l->right = r->left = NULL;

	for (y = N.right; y != NULL; y = y->right) {
		y->size = l_size;
		l_size -= 1 + node_size(y->left);
	}
	for (y = N.left; y != NULL; y = y->left) {
		y->size = r_size;
		r_size -= 1 + node_size(y->right);
	}
	
	l->right = n->left;
	r->left = n->right;
	n->left = N.right;
    n->right = N.left;
	
	return n;
}

static int height(splaytree_node *h) {
	int left_height, right_height;
	
	if(!h) { return 0; }
	
	left_height = 1 + height(h->left);
	right_height = 1 + height(h->right);
	
	return left_height > right_height ? left_height : right_height;
}

static splaytree* create_splaytree(int (*compare_function)(VALUE, VALUE)) {
	splaytree *tree = ALLOC(splaytree);
	tree->compare_function = compare_function;
	tree->root = NULL;
	return tree;
}

static splaytree_node* create_node(VALUE key, VALUE value) {
	splaytree_node *new_node = ALLOC(splaytree_node);
	new_node->key		= key;
	new_node->value		= value;
	new_node->left		= NULL;
	new_node->right		= NULL;
	return new_node;
}

static splaytree_node* insert(splaytree *tree, splaytree_node *n, VALUE key, VALUE value) {
	int cmp;
	splaytree_node *new_node;
	
	if (n) {
		n = splay(tree, n, key);
		cmp = tree->compare_function(key, n->key);
		if (cmp == 0) {
			n->value = value;
			return n;
		}
	}
	new_node = create_node(key, value);
	if (!n) {
		new_node->left = new_node->right = NULL;
	} else {
		cmp = tree->compare_function(key, n->key);
		if (cmp < 0) {
			new_node->left = n->left;
			new_node->right = n;
			n->left = NULL;
			n->size = 1 + node_size(n->right);
		} else {
			new_node->right = n->right;
			new_node->left = n;
			n->right = NULL;
			n->size = 1 + node_size(n->left);
		}
	}
	new_node->size = 1 + node_size(new_node->left) + node_size(new_node->right);
	return new_node;
}

static VALUE get(splaytree *tree, VALUE key) {
	int cmp;
	
	if (!tree->root)
		return Qnil;
		
	tree->root = splay(tree, tree->root, key);
	cmp = tree->compare_function(key, tree->root->key);
	if (cmp == 0) {
		return tree->root->value;
	}
	return Qnil;
}

static splaytree_node* delete(splaytree *tree, splaytree_node *n, VALUE key, VALUE *deleted) {
	int cmp, tsize;
	splaytree_node *x;
	
	tsize = n->size;
	n = splay(tree, n, key);
	cmp = tree->compare_function(key, n->key);
	if (cmp == 0) {
		*deleted = n->value;
		if (!n->left) {
			x = n->right;
		} else {
			x = splay(tree, n->left, key);
			x->right = n->right;
		}
		xfree(n);
		if (x) {
			x->size = tsize-1;
		}
		return x;
	}
	return n;
}

static splaytree* splaytree_each_node(splaytree *tree, splaytree_node *node, void (*each)(splaytree *tree_, splaytree_node *node_, void* args), void* arguments) {
	if (!node)
		return NULL;
	
		if (node->left)
			splaytree_each_node(tree, node->left, each, arguments);
		
		(*each)(tree, node, arguments);
		
		if (node->right)
			splaytree_each_node(tree, node->right, each, arguments);
	return tree;
}

static splaytree* splay_each(splaytree *tree, void (*each)(splaytree *tree, splaytree_node *node, void *args), void* arguments) {
	if (tree->root)
		splaytree_each_node(tree, tree->root, each, arguments);
	return tree;
}

// Methods to be called in Ruby

static VALUE id_compare_operator;

static int splaytree_compare_function(VALUE a, VALUE b) {
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

static VALUE splaytree_init(VALUE self)
{
	return self;
}

static void splaytree_mark(void *ptr) {
	ll_node *current, *new, *last, *old;
	if (ptr) {
		splaytree *tree = ptr;
		
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

static void splaytree_free(void *ptr) {
	if (ptr) {
		splaytree *tree = ptr;
		recursively_free_nodes(tree->root);
		xfree(tree);
	}
}

static VALUE splaytree_alloc(VALUE klass) {
	splaytree *tree = create_splaytree(&splaytree_compare_function);
	return Data_Wrap_Struct(klass, splaytree_mark, splaytree_free, tree);
}

static VALUE splaytree_push(VALUE self, VALUE key, VALUE value) {
	splaytree *tree = get_tree_from_self(self);
	tree->root = insert(tree, tree->root, key, value);
	return value;
}

static VALUE splaytree_get(VALUE self, VALUE key) {
	splaytree *tree = get_tree_from_self(self);
	return get(tree, key);
}

static VALUE splaytree_size(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	if(!tree->root) { return INT2NUM(0); }
	return INT2NUM(tree->root->size);
}

static VALUE splaytree_is_empty(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	return (tree->root ? Qfalse : Qtrue);
}

static VALUE splaytree_height(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	return INT2NUM(height(tree->root));
}

static VALUE splaytree_has_key(VALUE self, VALUE key) {
	splaytree *tree = get_tree_from_self(self);
	if(!tree->root) { return Qfalse; }
	if(get(tree, key) == Qnil)
		return Qfalse;
	
	return Qtrue;
}

static VALUE splaytree_min_key(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	splaytree_node *node;
	
	if(!tree->root)
		return Qnil;
	
	node = tree->root;
	while (node->left)
		node = node->left;
	
	return node->key;
}

static VALUE splaytree_max_key(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	splaytree_node *node;
	
	if(!tree->root)
		return Qnil;
	
	node = tree->root;
	while (node->right)
		node = node->right;
	
	return node->key;
}

static VALUE splaytree_delete(VALUE self, VALUE key) {
	VALUE deleted = Qnil;
	splaytree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	tree->root = delete(tree, tree->root, key, &deleted);
	return deleted;
}

static VALUE splaytree_clear(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	recursively_free_nodes(tree->root);
	tree->root = NULL;
	return Qnil;
}

static void splaytree_each_helper(splaytree *tree, splaytree_node *node, void *args) {
	rb_yield(rb_ary_new3(2, node->key, node->value));
};

static VALUE splaytree_each(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	splay_each(tree, &splaytree_each_helper, NULL);
	return self;
}

static VALUE CSplayTree;
static VALUE mContainers;

void Init_CSplayTreeMap() {
	id_compare_operator = rb_intern("<=>");
	
	mContainers = rb_define_module("Containers");
	CSplayTree = rb_define_class_under(mContainers, "CSplayTreeMap", rb_cObject);
	rb_define_alloc_func(CSplayTree, splaytree_alloc);
	rb_define_method(CSplayTree, "initialize", splaytree_init, 0);
	rb_define_method(CSplayTree, "push", splaytree_push, 2);
	rb_define_method(CSplayTree, "clear", splaytree_clear, 0);
	rb_define_alias(CSplayTree, "[]=", "push");
	rb_define_method(CSplayTree, "size", splaytree_size, 0);
	rb_define_method(CSplayTree, "empty?", splaytree_is_empty, 0);
	rb_define_method(CSplayTree, "height", splaytree_height, 0);
	rb_define_method(CSplayTree, "min_key", splaytree_min_key, 0);
	rb_define_method(CSplayTree, "max_key", splaytree_max_key, 0);
	rb_define_method(CSplayTree, "each", splaytree_each, 0);
	rb_define_method(CSplayTree, "get", splaytree_get, 1);
	rb_define_alias(CSplayTree, "[]", "get");
	rb_define_method(CSplayTree, "has_key?", splaytree_has_key, 1);
	rb_define_method(CSplayTree, "delete", splaytree_delete, 1);
	rb_include_module(CSplayTree, rb_eval_string("Enumerable"));
}
