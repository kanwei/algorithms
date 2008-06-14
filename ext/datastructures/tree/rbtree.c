#include "ruby.h"
#include <stdbool.h>

#define RED 1
#define BLACK 0

typedef struct struct_rbtree_node {
	bool color;
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

void recursively_free_nodes(rbtree_node *node) {
	if(node) {
		recursively_free_nodes(node->left);
		recursively_free_nodes(node->right);
		free(node);
	}
	return;
}

static rbtree* get_tree_from_self(VALUE self) {
	rbtree *tree;
	Data_Get_Struct(self, rbtree, tree);
	return tree;
}

bool isred(rbtree_node *node) {
	if(!node) {	return false; }
	
	if(node->color == RED) { return true; }
	else return false;
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
		new_node->num_nodes	= 1;
		new_node->left		= NULL;
		new_node->right		= NULL;
		return new_node;
	}
	
	// Do a top-down breaking of 4-nodes
	if ( isred(node->left) && isred(node->right) ) {
		colorflip(node);
	}
	
	// Insert left or right, recursively
	cmp = tree->compare_function(key, node->key);
	if 		(cmp == 0) 	{ node->value = value; }
	else if (cmp == -1) { node->left  = insert(tree, node->left, key, value); }
	else 				{ node->right = insert(tree, node->right, key, value); }
	
	// Fix our tree to keep left-lean
	if (isred(node->right))	{ node = rotate_left(node); }
	if (isred(node->left) && isred(node->left->left)) { node = rotate_right(node); }
	
	return set_num_nodes(node);
}

static VALUE get(rbtree *tree, rbtree_node *node, VALUE key) {
	int cmp;
	if (!node) {
		return Qnil;
	}
	
	cmp = tree->compare_function(key, node->key);
	if 		(cmp == 0) 	{ return node->value; }
	else if (cmp == -1) { return get(tree, node->left, key); }
	else 				{ return get(tree, node->right, key); }
	
}

static VALUE min(rbtree_node *node) {
	if (!node->left)
		return node->key;
		
	return min(node->left);
}

static VALUE max(rbtree_node *node) {
	if (!node->right)
		return node->key;
	
	return max(node->right);
}
	

// Ruby stuff

static int id_compare_operator;

static int rbtree_compare_function(VALUE a, VALUE b) {
  return FIX2INT(rb_funcall((VALUE) a, id_compare_operator, 1, (VALUE) b));
}

static VALUE rbtree_init(VALUE self)
{
    return self;
}

static void rbtree_free(rbtree *tree) {
	free(tree->root);
	free(tree);
}

static VALUE rbtree_alloc(VALUE klass) {
	rbtree *tree = create_rbtree(&rbtree_compare_function);
	return Data_Wrap_Struct(klass, NULL, rbtree_free, tree);
}

static VALUE rbtree_put(VALUE self, VALUE key, VALUE value) {
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

static VALUE rbtree_height(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	return INT2NUM(height(tree->root));
}

static VALUE rbtree_contains(VALUE self, VALUE key) {
	rbtree *tree = get_tree_from_self(self);
	if(get(tree, tree->root, key) == Qnil)
		return Qfalse;
	
	return Qtrue;
}

static VALUE rbtree_min(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	return min(tree->root);
}

static VALUE rbtree_max(VALUE self) {
	rbtree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	return max(tree->root);
}



VALUE cRBTree;
void Init_credblacktree() {
	id_compare_operator = rb_intern("<=>");
	
    cRBTree = rb_define_class("CRedBlackTree", rb_cObject);
	rb_define_alloc_func(cRBTree, rbtree_alloc);
    rb_define_method(cRBTree, "initialize", rbtree_init, 0);
    rb_define_method(cRBTree, "put", rbtree_put, 2);
    rb_define_method(cRBTree, "size", rbtree_size, 0);
    rb_define_method(cRBTree, "height", rbtree_height, 0);
    rb_define_method(cRBTree, "min", rbtree_min, 0);
    rb_define_method(cRBTree, "max", rbtree_max, 0);
    rb_define_method(cRBTree, "get", rbtree_get, 1);
    rb_define_method(cRBTree, "contains?", rbtree_contains, 1);
}