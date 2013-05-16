#include "ruby.h"

#define FALSE 0
#define TRUE 1

typedef struct struct_deque_node {
	VALUE obj;
	struct struct_deque_node *left;
	struct struct_deque_node *right;
} deque_node;

typedef struct {
	unsigned int size;
	deque_node *front;
	deque_node *back;
} deque;

void free_nodes(deque_node *node) {
	deque_node *next;
	while(node) {
		next = node->right;
		xfree(node);
		node = next;
	}
	return;
}

void clear_deque(deque *a_deque) {
	if(a_deque->front)
		free_nodes(a_deque->front);
	a_deque->size = 0;
	a_deque->front = NULL;
	a_deque->back = NULL;
	return;
}

static deque* get_deque_from_self(VALUE self) {
	deque *a_deque;
	Data_Get_Struct(self, deque, a_deque);
	return a_deque;
}

static deque* create_deque() {
	deque *a_deque = ALLOC(deque);
	a_deque->size = 0;
	a_deque->front = NULL;
	a_deque->back = NULL;
	return a_deque;
}

static deque_node* create_node(VALUE obj) {
	deque_node *node = ALLOC(deque_node);
	node->obj = obj;
	node->left = NULL;
	node->right = NULL;
	return node;
}

static void deque_mark(void *ptr) {
  if (ptr) {
		deque *deque = ptr;
		deque_node *node = deque->front;
		while(node) {
			rb_gc_mark(node->obj);
			node = node->right;
		}
	}
}

static void deque_free(void *ptr) {
	if (ptr) {
		deque *deque = ptr;
		free_nodes(deque->front);
		xfree(deque);
	}
}

static VALUE deque_alloc(VALUE klass) {
	deque *deque = create_deque();
	return Data_Wrap_Struct(klass, deque_mark, deque_free, deque);
}

static VALUE deque_push_front(VALUE self, VALUE obj) {
	deque *deque = get_deque_from_self(self);
	deque_node *node = create_node(obj);
	if(deque->front) {
		node->right = deque->front;
		deque->front->left = node;
		deque->front = node; 
	}
	else {
		deque->front = node;
		deque->back = node;
	}
	deque->size++;
	return obj;
}

static VALUE deque_push_back(VALUE self, VALUE obj) {
	deque *deque = get_deque_from_self(self);
	deque_node *node = create_node(obj);
	if(deque->back) {
		node->left = deque->back;
		deque->back->right = node;
		deque->back = node; 
	}
	else {
		deque->front = node;
		deque->back = node;
	}
	deque->size++;
	return obj;
}

static VALUE deque_pop_front(VALUE self) {
	deque *deque = get_deque_from_self(self);
	VALUE obj;
	if(!deque->front)
		return Qnil;
	deque_node *node = deque->front;
	obj = node->obj;
	if(deque->size == 1) {
		clear_deque(deque);
		return obj;
	}
	deque->front->right->left = NULL;
	deque->front = deque->front->right;
	deque->size--;
	return obj;
}

static VALUE deque_front(VALUE self) {
	deque *deque = get_deque_from_self(self);
	if(deque->front)
		return deque->front->obj;
	
	return Qnil;
}

static VALUE deque_back(VALUE self) {
	deque *deque = get_deque_from_self(self);
	if(deque->back)
		return deque->back->obj;
	
	return Qnil;
}

static VALUE deque_pop_back(VALUE self) {
	deque *deque = get_deque_from_self(self);
	VALUE obj;
	if(!deque->back)
		return Qnil;
	deque_node *node = deque->back;
	obj = node->obj;
	if(deque->size == 1) {
		clear_deque(deque);
		return obj;
	}
	deque->back->left->right = NULL;
	deque->back = deque->back->left;
	deque->size--;
	return obj;
}

static VALUE deque_clear(VALUE self) {
	deque *deque = get_deque_from_self(self);
	clear_deque(deque);
	return Qnil;
}

static VALUE deque_size(VALUE self) {
	deque *deque = get_deque_from_self(self);
	return INT2NUM(deque->size);
}

static VALUE deque_is_empty(VALUE self) {
	deque *deque = get_deque_from_self(self);
	return (deque->size == 0) ? Qtrue : Qfalse;
}

static VALUE deque_each_forward(VALUE self) {
	deque *deque = get_deque_from_self(self);
	deque_node *node = deque->front;
	while(node) {
		rb_yield(node->obj);
		node = node->right;
	}
	return self;
}

static VALUE deque_each_backward(VALUE self) {
	deque *deque = get_deque_from_self(self);
	deque_node *node = deque->back;
	while(node) {
		rb_yield(node->obj);
		node = node->left;
	}
	return self;
}

static VALUE deque_init(int argc, VALUE *argv, VALUE self)
{
	long len, i;
	VALUE ary;
	
	if(argc == 0) {
		return self;
	}
	else if(argc > 1) {
		rb_raise(rb_eArgError, "wrong number of arguments");
	}
	else {
		ary = rb_check_array_type(argv[0]);
		if(!NIL_P(ary)) {
			len = RARRAY_LEN(ary);
			for (i = 0; i < len; i++) {
				deque_push_back(self, RARRAY_PTR(ary)[i]);
			}
		}
	}
	return self;
}

static VALUE cDeque;
static VALUE mContainers;

void Init_CDeque() {
	mContainers = rb_define_module("Containers");
	cDeque = rb_define_class_under(mContainers, "CDeque", rb_cObject);
	rb_define_alloc_func(cDeque, deque_alloc);
	rb_define_method(cDeque, "initialize", deque_init, -1);
	rb_define_method(cDeque, "push_front", deque_push_front, 1);
	rb_define_method(cDeque, "push_back", deque_push_back, 1);
	rb_define_method(cDeque, "clear", deque_clear, 0);
	rb_define_method(cDeque, "front", deque_front, 0);
	rb_define_method(cDeque, "back", deque_back, 0);
	rb_define_method(cDeque, "pop_front", deque_pop_front, 0);
	rb_define_method(cDeque, "pop_back", deque_pop_back, 0);
	rb_define_method(cDeque, "size", deque_size, 0);
	rb_define_alias(cDeque, "length", "size");
	rb_define_method(cDeque, "empty?", deque_is_empty, 0);
	rb_define_method(cDeque, "each_forward", deque_each_forward, 0);
	rb_define_method(cDeque, "each_backward", deque_each_backward, 0);
	rb_define_alias(cDeque, "each", "each_forward");
	rb_define_alias(cDeque, "reverse_each", "each_backward");
	rb_include_module(cDeque, rb_eval_string("Enumerable"));
}