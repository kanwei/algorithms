#include "ruby.h"

typedef struct struct_bst_node {
	VALUE key;
	VALUE value;
	struct struct_bst_node *left;
	struct struct_bst_node *right;
	struct struct_bst_node *parent;
} bst_node;

typedef struct struct_bst {
	bst_node *root;
	int (*compare_function)(VALUE key1, VALUE key2);
	unsigned int size; 
} bst;

static VALUE bst_initialize(VALUE self) {
	return self;
}

static bst* get_bst_from_self(VALUE self) {
	bst *tree;
	Data_Get_Struct(self, bst, tree);
	return tree;
}

static bst* bst_each_node(bst *tree, bst_node *node, void (*each)(bst *tree_, bst_node *node_, void* args), void* arguments) {
	if (!node)
		return NULL;
	
		if (node->left)
			bst_each_node(tree, node->left, each, arguments);
		
		(*each)(tree, node, arguments);
		
		if (node->right)
			bst_each_node(tree, node->right, each, arguments);
	return tree;
}

static bst* bst_each(bst *tree, void (*each)(bst *tree, bst_node *node, void *args), void* arguments) {
	if (tree->root)
		bst_each_node(tree, tree->root, each, arguments);
	return tree;
}

static VALUE id_compare_operator;

static int bst_compare_function(VALUE a, VALUE b) {
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

static void insert_element(bst *tree, bst_node **t,bst_node *newElement) {
	int cmp;
	bst_node *y = NULL;
	bst_node *x = *t;
	while (x != NULL) {
		y = x;
		cmp = tree->compare_function(newElement->key, x->key);
		if (cmp < 0) x = x->left;
		else x = x->right;
	}
	newElement->parent = y;
	if (y == NULL) *t = newElement;
	else {
		cmp = tree->compare_function(newElement->key, y->key);
		if (cmp < 0)
		 	y->left = newElement;
		else 
			y->right = newElement;
	}
}


static bst_node* create_node(VALUE key_value,VALUE value) {
	bst_node *new_node = ALLOC(bst_node);
	new_node->value = value;
	new_node->key = key_value;
	new_node->left = NULL;
	new_node->right = NULL;
	new_node->parent = NULL;
	return new_node;	 
}

static bst_node* tree_minimum (bst_node *tree) {
	bst_node *x = tree;
	while (x->left) x = x->left;
	return x;
}

static bst_node* tree_maximum (bst_node *tree) {
	bst_node *x = tree;
	while (x->right) x = x->right;
	return x;
}

static bst_node* node_successor (bst_node *tree,bst_node *x) {
	if (x->right) return tree_minimum(x->right);
	bst_node *y = x->parent;
	while (y && x == y->right) {
		x = y;
		y = x->parent;
	}
	return y;
}


static bst_node* delete_node (bst_node **tree,bst_node *tobeDeleted) {
	bst_node *y,*x;

	if ((tobeDeleted->left == NULL) || (tobeDeleted->right == NULL)) y = tobeDeleted;
	else y = node_successor(*tree,tobeDeleted);

	if (y->left) x = y->left;
	else x = y->right;

	if (x) x->parent = y->parent;

	if (y->parent == NULL) {
		*tree = x;
		return y;
	} else if (y == y->parent->left) {
		y->parent->left = x;
	} else {
		y->parent->right = x;
	}

	if (tobeDeleted != y) tobeDeleted->key = y->key;
	return y;
}

static bst_node* search_node(bst *tree, bst_node *node, VALUE key) {
	bst_node *x = node;
	int cmp;
	
	while(x) {
		cmp = tree->compare_function(key, x->key);
		if (cmp == 0) return x;
		else if (cmp < 0) { x = x->left; }
		else { x = x->right; }
	}
	return NULL;
}

static void recursively_mark_nodes(bst_node *node) {
	if(node) {
		rb_gc_mark(node->key);
		rb_gc_mark(node->value);
		recursively_mark_nodes(node->left);
		recursively_mark_nodes(node->right);
	}
}

static void bst_mark(bst *tree) {
	if (tree) {
		recursively_mark_nodes(tree->root);
	}
}

static void recursively_free_nodes(bst_node *node) {
	if(node) {
		recursively_free_nodes(node->left);
		recursively_free_nodes(node->right);
		xfree(node);
	}
}

static void bst_free(bst *tree) {
	if (tree) {
		recursively_free_nodes(tree->root);
	}
}

static bst* create_bst(int (*compare_function)(VALUE, VALUE)) {
	bst *tree = ALLOC(bst);
	tree->compare_function = compare_function;
	tree->root = NULL;
	tree->size = 0;
	return tree;
}

static VALUE bst_alloc(VALUE klass) {
	bst *tree = create_bst(&bst_compare_function);
	return Data_Wrap_Struct(klass, bst_mark, bst_free, tree);
}

static VALUE rb_bst_push_value(VALUE self, VALUE key, VALUE value) {
	bst *tree = get_bst_from_self(self);
	insert_element(tree, &(tree->root), create_node(key,value));
	tree->size++;
	return self;
}

static void bst_each_helper(bst *tree, bst_node *node, void *args) {
	rb_yield(rb_ary_new3(2, node->key, node->value));
};

static VALUE rb_bst_each(VALUE self) {
	bst *tree = get_bst_from_self(self);
	bst_each(tree, &bst_each_helper, NULL);
	return self;
}

static VALUE rb_bst_delete(VALUE self, VALUE key) {
	bst *tree = get_bst_from_self(self);
	bst_node *tobeDeleted = search_node(tree, tree->root, key);
	if(tobeDeleted) { 
		tree->size -= 1;
		bst_node *deletedNode = delete_node(&(tree->root),tobeDeleted);
		return deletedNode->value;
	}
	return Qnil;
}

static VALUE rb_bst_size(VALUE self) { 
	bst *tree;
	Data_Get_Struct(self,bst,tree);
	return INT2FIX(tree->size);
}

static VALUE CBst;
static VALUE mContainers;

void Init_CBst() {
	id_compare_operator = rb_intern("<=>");

	mContainers = rb_define_module("Containers");
	CBst = rb_define_class_under(mContainers, "CBst", rb_cObject);
	rb_define_alloc_func(CBst, bst_alloc);
	rb_define_method(CBst, "initialize", bst_initialize, 0);
	rb_define_method(CBst, "push", rb_bst_push_value, 2);
	rb_define_alias(CBst, "[]=", "push");
	rb_define_method(CBst, "each", rb_bst_each, 0);
	rb_define_method(CBst, "delete", rb_bst_delete, 1);
	rb_define_method(CBst, "size", rb_bst_size, 0);
}
