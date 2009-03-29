#include "ruby.h"

typedef struct struct_splaytree_node {
	VALUE key;
	VALUE value;
	struct struct_splaytree_node *left;
	struct struct_splaytree_node *right;
} splaytree_node;

typedef struct {
	int (*compare_function)(VALUE key1, VALUE key2);
	int size;
	splaytree_node *root;
	splaytree_node *header;
} splaytree;

static void recursively_free_nodes(splaytree_node *node) {
	if(node) {
		recursively_free_nodes(node->left);
		recursively_free_nodes(node->right);
		free(node);
	}
	return;
}

static splaytree* get_tree_from_self(VALUE self) {
	splaytree *tree;
	Data_Get_Struct(self, splaytree, tree);
	return tree;
}

static void splay(splaytree *tree, VALUE key) {
	int cmp, cmp2;
	splaytree_node *l, *r, *t, *y;
	
	l = tree->header;
	r = tree->header;
	t = tree->root;
	
	tree->header->left = NULL;
	tree->header->right = NULL;
	
	while(1) {
		cmp = tree->compare_function(key, t->key);
		if (cmp == -1) {
			if (!(t->left)) break;
			cmp2 = tree->compare_function(key, t->left->key);
			if (cmp2 == -1) {
				y = t->left;
				t->left = y->right;
				y->right = t;
				t = y;
          		if (!(t->left)) break;
			}
			r->left = t;
			r = t;
			t = t->left;
		}
		else if (cmp == 1) {
			if (!(t->right)) break;
			cmp2 = tree->compare_function(key, t->right->key);
			if (cmp2 == 1) {
				y = t->right;
				t->right = y->left;
				y->left = t;
				t = y;
          		if (!(t->right)) break;
			}
			l->right = t;
			l = t;
			t = t->right;
		} else {
			break;
		}
	}
	l->right = t->left;
	r->left = t->right;
	t->left = tree->header->right;
    t->right = tree->header->left;
	tree->root = t;
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
	tree->size = 0;
	tree->header = ALLOC(splaytree_node);
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

static void insert(splaytree *tree, VALUE key, VALUE value) {
	int cmp;
	splaytree_node *new_node;
	
	if (!(tree->root)) {
		new_node = create_node(key, value);
		tree->root = new_node;
		tree->size += 1;
		return;
	}
	
	splay(tree, key);
	cmp = tree->compare_function(key, tree->root->key);
	if (cmp == 0) {
		tree->root->value = value;
		return;
	} else {
		new_node = create_node(key, value);
		if (cmp == -1) { 
			new_node->left = tree->root->left;
			new_node->right = tree->root;
			tree->root->left = NULL;
		} else { /* cmp == 1 */
			new_node->right = tree->root->right;
			new_node->left = tree->root;
			tree->root->right = NULL;
		}
		tree->root = new_node;
		tree->size += 1;
	}
}

static VALUE get(splaytree *tree, VALUE key) {
	int cmp;
	if (!tree->root)
		return Qnil;
	
	splay(tree, key);
	cmp = tree->compare_function(key, tree->root->key);
	if (cmp == 0) {
		return tree->root->value;
	}
	return Qnil;
}

static VALUE min_key(splaytree_node *node) {
	if (!node->left)
		return node->key;
		
	return min_key(node->left);
}

static VALUE max_key(splaytree_node *node) {
	if (!node->right)
		return node->key;
	
	return max_key(node->right);
}

static VALUE delete(splaytree *tree, VALUE key) {
	int cmp;
	splaytree_node *x, *deleted_root;
	VALUE deleted;

	splay(tree, key);
	cmp = tree->compare_function(key, tree->root->key);
	if (cmp == 0) {
		deleted = tree->root->value;
		deleted_root = tree->root;
		if (!(tree->root->left)) {
			tree->root = tree->root->right;
		} else {
			x = tree->root->right;
			tree->root = tree->root->left;
			splay(tree, key);
			tree->root->right = x;
		}
		free(deleted_root);
		tree->size -= 1;
		return deleted;
	}
	return Qnil;
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

static int id_compare_operator;

static int splaytree_compare_function(VALUE a, VALUE b) {
	if (a == b) return 0;
	if (FIXNUM_P(a) && FIXNUM_P(b)) {
		long x = FIX2LONG(a), y = FIX2LONG(b);
		if (x == y) return 0;
		if (x > y) return 1;
		return -1;
	}
	if (TYPE(a) == T_STRING && RBASIC(a)->klass == rb_cString &&
			TYPE(b) == T_STRING && RBASIC(b)->klass == rb_cString) {
		return rb_str_cmp(a, b);
	}
	return FIX2INT(rb_funcall((VALUE) a, id_compare_operator, 1, (VALUE) b));
}

static VALUE splaytree_init(VALUE self)
{
	return self;
}

static void recursively_mark_nodes(splaytree_node *node) {
	if(node) {
		rb_gc_mark(node->key);
		rb_gc_mark(node->value);
		recursively_mark_nodes(node->left);
		recursively_mark_nodes(node->right);
	}
}

static void splaytree_mark(void *ptr) {
	if (ptr) {
		splaytree *tree = ptr;
		recursively_mark_nodes(tree->root);
	}
}

static void splaytree_free(void *ptr) {
	if (ptr) {
		splaytree *tree = ptr;
		recursively_free_nodes(tree->root);
		free(tree->header);
		free(tree);
	}
}

static VALUE splaytree_alloc(VALUE klass) {
	splaytree *tree = create_splaytree(&splaytree_compare_function);
	return Data_Wrap_Struct(klass, splaytree_mark, splaytree_free, tree);
}

static VALUE splaytree_push(VALUE self, VALUE key, VALUE value) {
	splaytree *tree = get_tree_from_self(self);
	insert(tree, key, value);
	return value;
}

static VALUE splaytree_get(VALUE self, VALUE key) {
	splaytree *tree = get_tree_from_self(self);
	return get(tree, key);
}

static VALUE splaytree_size(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	return INT2NUM(tree->size);
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
	if(!tree->root)
		return Qnil;
	
	return min_key(tree->root);
}

static VALUE splaytree_max_key(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	return max_key(tree->root);
}

static VALUE splaytree_delete(VALUE self, VALUE key) {
	splaytree *tree = get_tree_from_self(self);
	if(!tree->root)
		return Qnil;
	
	return delete(tree, key);
}

static VALUE splaytree_clear(VALUE self) {
	splaytree *tree = get_tree_from_self(self);
	recursively_free_nodes(tree->root);
	tree->root = NULL;
	tree->size = 0;
	
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
