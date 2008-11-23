#include "ruby.h"
#include <ctype.h>

#ifndef RSTRING_PTR
#define RSTRING_PTR(s) (RSTRING(s)->ptr)
#endif

/* for compatibility with Ruby 1.8.5, which doesn't declare RSTRING_LEN */
#ifndef RSTRING_LEN
#define RSTRING_LEN(s) (RSTRING(s)->len)
#endif

typedef struct Node {
  int key;
  VALUE data;
  struct Node *left;
  struct Node *right;
  struct Node *parent;
} Node;


typedef struct cBst {
  Node *head;
} cBst;

static VALUE bst_initialize(VALUE self) {
  return self;
}

static void inOrderDisplay (Node *root) {
  if (root) {
    inOrderDisplay(root->left);
    rb_yield(rb_assoc_new(INT2FIX(root->key),root->data));
    inOrderDisplay(root->right);
  }
}

static void insertElement(Node **root,Node *newElement) {
  Node *y = NULL;
  Node *x = *root;
  while (x != NULL) {
    y = x;
    if (newElement->key < x->key) x = x->left;
    else x = x->right;
  }
  newElement->parent = y;
  if (y == NULL) *root = newElement;
  else if (newElement->key < y->key) y->left = newElement;
  else y->right = newElement;
}

static Node *createElement(VALUE key_data,VALUE data) {
  int key = FIX2INT(key_data);
  Node *arbit = malloc(sizeof(Node));
  arbit->data = data;
  arbit->key = key;
  arbit->left = NULL;
  arbit->right = NULL;
  arbit->parent = NULL;
  return arbit;  
}


static Node *treeMinimum (Node *root) {
  Node *x = root;
  while (x->left) x = x->left;
  return x;
}


static Node *treeMaximum (Node *root) {
  Node *x = root;
  while (x->right) x = x->right;
  return x;
}

// I do not fully understand this method.
static Node *nodeSuccessor (Node *root,Node *x) {
  if (x->right) return treeMinimum(x->right);
  Node *y = x->parent;
  while (y && x == y->right) {
    x = y;
    y = x->parent;
  }
  return y;
}


Node *deleteNode (Node **root,Node *tobeDeleted) {
  Node *y,*x;
  
  if ((tobeDeleted->left == NULL) || (tobeDeleted->right == NULL)) y = tobeDeleted;
  else y = nodeSuccessor(*root,tobeDeleted);
  
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

Node *searchNode (Node *root,int key) {
  Node *x = root;
  while (x) {
    if (x->key == key) return x;
    else if (key < x->key) x = x->left;
    else x = x->right;
  }
}

void deleteNodesRecur(Node *root) {
  if(root) {
    deleteNodesRecur(root->left);
    if(root) free(root);
    deleteNodesRecur(root->right);
  }
}

static void bst_free_node(void *p) {
  cBst *headNode = (cBst *)p;
  deleteNodesRecur(headNode->head);
}

static VALUE bst_alloc(VALUE klass) {
  cBst *headNode = ALLOC(cBst);
  headNode->head = NULL;
  VALUE obj;
  obj = Data_Wrap_Struct(klass,NULL,bst_free_node,headNode);
  return obj;
}


static VALUE rb_bst_insert_value(VALUE self,VALUE key,VALUE data) {
  cBst *headNode;
  Data_Get_Struct(self,cBst,headNode);
  insertElement(&(headNode->head),createElement(key,data));
  return self;
}

/* data structure builds up a stack for traversal, delete can be harmful */
static VALUE rb_bst_each(VALUE self)
{
  cBst *headNode;
  Data_Get_Struct(self,cBst,headNode);
  inOrderDisplay(headNode->head);
  return Qnil;
}

static VALUE rb_bst_delete(VALUE self,VALUE keyVal) {
  int key = FIX2INT(keyVal);
  cBst *headNode;
  Data_Get_Struct(self,cBst,headNode);
  Node *tobeDeleted = searchNode(headNode->head,key);
  Node *deletedNode = deleteNode(&(headNode->head),tobeDeleted);
  return deletedNode->data;
}

static VALUE mContainers;

void Init_CBst() {
  mContainers = rb_define_module("Containers");
  VALUE packet_bst_class = rb_define_class_under(mContainers,"CBst",rb_cObject);
  rb_define_alloc_func(packet_bst_class,bst_alloc);
  rb_define_method(packet_bst_class,"initialize",bst_initialize,0);
  rb_define_method(packet_bst_class,"insert",rb_bst_insert_value,2);
  rb_define_method(packet_bst_class,"each", rb_bst_each,0);
  rb_define_method(packet_bst_class,"delete",rb_bst_delete,1);
}


