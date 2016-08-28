#|
\chapter{}
@section The Elements of Programming

This section presents the three main ideas of programming: primitive
expressions, means of combination, and means of abstraction.


@subsection Expressions

The first of the three elements of programming introduced are expressions.
Expressions represent the simplest bits of the language, and can be combined
using procedures. Combinations are delimited by parenthesis and consist of an
operator and an operand. Lisp uses prefix notation, so the operator will always
be on the left hand side prefixing the operands.


@subsection Naming and the Environment

Define is introduced as the simplest means of abstraction. Complex programs are
built in increasing complexity one step at a time. The environment keeps track
of name-object pairs.


@subsection Evaluating Combinations

The evaluation rule is recursive. Exceptions to the general evaluation rule are
called special forms.


@subsection Compound Procedures

A procedure definition has a name, formal parameters, and a body. For example
the square procedure can be defined as

@code
(defun square (x) (* x x))
;; And it can be used to define new procedures such as sum of squares.
(defun sum-of-squares (x y) (+ (square x) (square y)))
@end code


@subsection The Substitution Model for Procedure Application

To apply a compound procedure to arguments, evaluate the body of the procedure
with each formal parameter replaces by the corresponding argument. An example of
this can be seen in evaluating the sum-of-squares function

@code
(sum-of-squares 5 6)
(+ (square 5) (square 6))
(+ (* 5 5) (* 6 6))
(+ 25 36)
61
@end code


@subsection Conditional Expressions and Predicates

Conditionals evaluate predicates until one of them returns true.


@subsubsection Exercise 1.1

@code
10
12
8
3
6
A
B
19
nil
3
16
6
16
@end code


@subsubsection Exercise 1.2

@code
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5)))))
   (* 3 (- 6 2) (- 2 7)))
@end code


@subsubsection Exercise 1.3

Given three inputs a, b, and c provides us with the following possible
combinations: ab, ac, bc. Since the text is assuming you only know conditionals
at this point I'll be using them.

@code
(defun f (a b c)
  (if (> a b)
      (sum-of-squares a (if (> b c) b c))
      (sum-of-squares b (if (> c a) c a))))
@end code


@subsubsection Exercise 1.4

@code
(define a-plus-abs-b a b)
  ((if (> b 0) + -) a b)
@end code

This exercise isn't valid Common Lisp, so I'll define a functionally equivalent
procedure.

@code
(defun a-plus-abs-b (a b)
  (funcall (if (> b 0) #'+ #'-) a b))
@end code

The procedure applies the function + to the arguments if @emph{b} is positive,
otherwise it applies the function - to the arguments. The result of this is the
product of @emph{a} and the absolute value of @emph{b}. The reason the exercise
had to be rewritten for Common Lisp is because Common Lisp uses a separate
namespace for functions and variables. Since there is a separate namespace we
have to deliberately state what we're using is a function (using the \#' read
macro) and apply it to arguments using funcall.


@subsubsection Exercise 1.5

Firstly I'll translate the example into Common Lisp.

@code
(defun p () (funcall #'p))
(defun test (x y)
  (if (= x 0)
      0
      y))
@end code

Note that the function p will result an infinite loop recursively calling itself
until the end of time. Using an interpreter with applicative-order evaluation
will result in the execution of the function p meaning that 0 is never returned,
while an interpreter using normal-order evaluation will never execute the
function p allowing 0 to be returned. This is because applicative-order
evaluation evaluates its arguments before passing them to a function.

@subsection Example: Square Roots by Newton's Method

Newton's method of successive approximations can be used to determine roots to a
desired accuracy. Given a guess y and a number x we can average y with x/y to
get closer.


@subsubsection Exercise 1.6

When Alyssa attempts to use new-if in the sqrt-iter function it will enter an
infinite loop because the interpreter is using applicative-order evaluation
which evaluates all of the arguments given to a function. The only reason the
standard if doesn't do this is because it's a special form.


@subsubsection Exercise 1.7

@code
(defun sqrt-iter (guess x)
  (if (good-enough-p guess x)
      guess
      (sqrt-iter (improve guess x)
                 x)))

(defun improve (guess x)
  (average guess (/ x guess)))

(defun average (x y)
  (/ (+ x y) 2))

(defun good-enough-p (guess x)
  (< (abs (- (square guess) x )) 0.001))

(defun square-root (x)
  (sqrt-iter 1.0 x))
@end code

Since our implementation of good-enough-p is only accurate up to 0.001 finding
the root of small numbers such as 0.00009 will be wildly inaccurate.

@code
(square-root 0.00009)
0.032203242
@end code

The correct answer is approximately 0.009486833 which is far off from our
answer. Large numbers will also be inaccurate due to limited floating point
precision meaning we can only store a limited number of bytes to represent a
floating point number.

@code
(square-root 100857907935446422559457150)
; Evaluation aborted on #<FLOATING-POINT-OVERFLOW ... >.
@end code

This shows that the number is far too large to fit into the limited number of
bytes we use to represent a floating point number. An alternative method for
implementing good-enough-p would be to watch the value and stop when only a
small change occurs.

@code
(defun good-enough-p (guess x)
  (< (abs (- guess (improve guess x))) 0.001))
@end code

While this method works a bit better than the previous it is still a very
incomplete solution. It does, however, work on both smaller and larger numbers
to a grater accuracy than the previous method.

@code
(square-root 0.00009)
0.009635425
(square-root 100857907935446422559457150)
1.0042804e13
@end code


@subsubsection Exercise 1.8

This exercise is fairly simple, just modify the improve function to match the
formula \( \frac{x/y^2 + 2y} 3 \) then adjust good-enough-p to cube the guess
instead of squaring it.

@code
(defun cube (x) (* (square x) x))
(defun cbrt-iter (guess x)
  (if (good-enough-p guess x)
      guess
      (cbrt-iter (improve guess x)
                 x)))

(defun improve (guess x)
  (/ (+ (/ x (square guess)) (* 2 guess))
     3))

(defun good-enough-p (guess x)
  (< (abs (- (cube guess) x )) 0.001))

(defun cubed-root (x)
  (cbrt-iter 1.0 x))
@end code


@subsection Procedures as Black-Box Abstractions

It is important for procedures to have a distinct suppressible task. This task
should be executed in a modular way such that it can be used anywhere else
without having to understand the internals.

|#
