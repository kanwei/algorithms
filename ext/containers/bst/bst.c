#include "ruby.h"
#include <ctype.h>

#ifndef RSTRING_PTR
#define RSTRING_PTR(s) (RSTRING(s)->ptr)
#endif

/* for compatibility with Ruby 1.8.5, which doesn't declare RSTRING_LEN */
#ifndef RSTRING_LEN
#define RSTRING_LEN(s) (RSTRING(s)->len)
#endif

typedef struct struct_bst_node {
  VALUE key;
  VALUE data;
  struct struct_bst_node *left;
  struct struct_bst_node *right;
  struct struct_bst_node *parent;
} bst_node;


typedef struct struct_bst_head {
  bst_node *head; 
  unsigned int size; 
} bst_head;

static VALUE bst_initialize(VALUE self) {
  return self;
}

static void in_order_display (bst_node *root) {
  if (root) {
    in_order_display(root->left);
    rb_yield(rb_assoc_new(root->key,root->data));
    in_order_display(root->right);
  }
}

static int id_compare_operator;

static int rb_key_compare(VALUE a, VALUE b) {
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

static void insert_element(bst_node **root,bst_node *newElement) {
  bst_node *y = NULL;
  bst_node *x = *root;
  while (x != NULL) {
    y = x;
    //if (newElement->key < x->key) x = x->left;
    if (rb_key_compare(newElement->key,x->key) < 0) x = x->left;
    else x = x->right;
  }
  newElement->parent = y;
  if (y == NULL) *root = newElement;
  //else if (newElement->key < y->key) y->left = newElement;
  else if (rb_key_compare(newElement->key,y->key) < 0) y->left = newElement;
  else y->right = newElement;
}


static bst_node *create_element(VALUE key_data,VALUE data) {
  bst_node *arbit = malloc(sizeof(bst_node));
  arbit->data = data;
  arbit->key = key_data;
  arbit->left = NULL;
  arbit->right = NULL;
  arbit->parent = NULL;
  return arbit;  
}


static bst_node *tree_minimum (bst_node *root) {
  bst_node *x = root;
  while (x->left) x = x->left;
  return x;
}


static bst_node *tree_maximum (bst_node *root) {
  bst_node *x = root;
  while (x->right) x = x->right;
  return x;
}

static bst_node *node_successor (bst_node *root,bst_node *x) {
  if (x->right) return tree_minimum(x->right);
  bst_node *y = x->parent;
  while (y && x == y->right) {
    x = y;
    y = x->parent;
  }
  return y;
}


bst_node *delete_node (bst_node **root,bst_node *tobeDeleted) {
  bst_node *y,*x;
  
  if ((tobeDeleted->left == NULL) || (tobeDeleted->right == NULL)) y = tobeDeleted;
  else y = node_successor(*root,tobeDeleted);
  
  if (y->left) x = y->left;
  else x = y->right;
  
  if (x) x->parent = y->parent;
  
  if (y->parent == NULL) {
    *root = x;
    return y;
  } else if (y == y->parent->left) {
    y->parent->left = x;
  } else {
    y->parent->right = x;
  }
  
  if (tobeDeleted != y) tobeDeleted->key = y->key;
  return y;
}

bst_node *search_node (bst_node *root,VALUE key) {
  bst_node *x = root;
  while (x) {
    //if (x->key == key) return x;
    if (rb_key_compare(x->key,key) == 0) return x;
    //else if (key < x->key) x = x->left;
    else if (rb_key_compare(key,x->key) < 0) x = x->left;
    else x = x->right;
  }
  return NULL;
}

static void mark_nodes_recur(bst_node *root) {
  if(root) {
    rb_gc_mark(root->key);
    rb_gc_mark(root->data);
    mark_nodes_recur(root->left);
    mark_nodes_recur(root->right);
  }
}

static void bst_mark_node(void *ptr) {
  if (ptr) {
    bst_head *headNode = ptr;
    mark_nodes_recur(headNode->head);
  }
}

void delete_nodes_recur(bst_node *root) {
  if(root) {
    delete_nodes_recur(root->left);
    delete_nodes_recur(root->right);
    free(root);
  }
}

static void bst_free_node(void *ptr) {
  if (ptr) {
    bst_head *headNode = ptr;
    delete_nodes_recur(headNode->head);
  }
}

static VALUE bst_alloc(VALUE klass) {
  bst_head *headNode = ALLOC(bst_head);
  headNode->head = NULL;
  headNode->size = 0;
  VALUE obj;
  obj = Data_Wrap_Struct(klass,bst_mark_node,bst_free_node,headNode);
  return obj;
}

static VALUE rb_bst_insert_value(VALUE self,VALUE key,VALUE data) {
  bst_head *headNode;
  Data_Get_Struct(self,bst_head,headNode);
  insert_element(&(headNode->head),create_element(key,data));
  headNode->size++;
  return self;
}

/* data structure builds up a stack for traversal, delete can be harmful */
static VALUE rb_bst_each(VALUE self)
{
  bst_head *headNode;
  Data_Get_Struct(self,bst_head,headNode);
  in_order_display(headNode->head);
  return Qnil;
}

static VALUE rb_bst_delete(VALUE self,VALUE keyVal) {
  //int key = FIX2INT(keyVal);
  bst_head *headNode;
  Data_Get_Struct(self,bst_head,headNode);
  bst_node *tobeDeleted = search_node(headNode->head,keyVal);
  if(tobeDeleted) { 
    headNode->size = headNode->size - 1;
    bst_node *deletedNode = delete_node(&(headNode->head),tobeDeleted);
    return deletedNode->data;
  } else { 
    rb_raise(rb_eArgError, "Key was not found");
    return Qnil;
  }
}

static VALUE rb_bst_size(VALUE self) { 
  bst_head *headNode;
  Data_Get_Struct(self,bst_head,headNode);
  return INT2FIX(headNode->size);
}

static VALUE mContainers;

void Init_CBst() {
  id_compare_operator = rb_intern("<=>");
  mContainers = rb_define_module("Containers");
  VALUE cbst_class = rb_define_class_under(mContainers,"CBst",rb_cObject);
  rb_define_alloc_func(cbst_class,bst_alloc);
  rb_define_method(cbst_class,"initialize",bst_initialize,0);
  rb_define_method(cbst_class,"insert",rb_bst_insert_value,2);
  rb_define_method(cbst_class,"each", rb_bst_each,0);
  rb_define_method(cbst_class,"delete",rb_bst_delete,1);
  rb_define_method(cbst_class,"size",rb_bst_size,0);
}
