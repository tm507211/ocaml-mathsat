(** MathSAT 5 *)

(** {2 Data types} *)

(** MathSAT configuration. *)
type msat_config

(** MathSAT environment. *)
type msat_env

(** MathSAT term.

    A term is a constant, a number, an atom, or an arbitrary boolean combination
    of those. It is the basic block of MathSAT abstract syntax trees.  *)
type msat_term

(** MathSAT declaration.

    Declaration of constants and uninterpreted functions/predicates. *)
type msat_decl

(** MathSAT data types. *)
type msat_type

(** MathSAT model. *)
type msat_model

(** MathSAT result. *)
type msat_result =
| Sat
| Unsat
| Unknown

(** MathSAT truth value. *)
type msat_truth_value

(** MathSAT symbol tag. *)
type msat_symbol_tag

type size_t = int

exception MSAT_error

val msat_result_to_string : msat_result -> string

(** {2 Environment creation} *)

(** Creates a new MathSAT configuration *)
external msat_create_config : unit -> msat_config = "wrapper_msat_create_config"

(** Creates a new MathSAT configuration by parsing the given data.
    
    The format for the configuration data is simply one "key = value" entry
    per line. The data may include comments, prefixed by the # character (and
    extending until the end of the line). *)
external msat_parse_config : string -> msat_config = "wrapper_msat_parse_config"

(** Destroys a configuration.

    It is an error to destroy a configuration that is still being used by an
    environment. *)
external msat_destroy_config : msat_config -> unit = "wrapper_msat_destroy_config"

(** Creates a new MathSAT environment from the given configuration. *)
external msat_create_env : msat_config -> msat_env = "wrapper_msat_create_env"

(** Creates an environment that can share terms with its [sibling]. *)
external msat_create_shared_env : msat_config -> msat_env -> msat_env = "wrapper_msat_create_shared_env"

(** Destroys an environment. *)
external msat_destroy_env : msat_env -> unit = "wrapper_msat_destroy_env"

(** Performs garbage collection on the given environment.
    
    This function will perform garbage collection on the given environment.  All
    the internal caches of the environment will be cleared (including those in
    the active solvers and preprocessors). If the environment is not shared, all
    the terms that are not either in [tokeep] or in the current asserted
    formulas will be deleted. *)
val msat_gc_env : msat_env -> msat_term list -> unit

(**  Sets an option in the given configuration.
     
     Notice that the best thing to do is set options right after having
     created a configuration, before creating an environment with it. The
     library tries to capture and report errors, but it does not always
     succeed. *)
val msat_set_option : msat_config -> string -> string -> unit

(** Returns the data type for Booleans in the given env. *)
external msat_get_bool_type : msat_env -> msat_type = "wrapper_msat_get_bool_type"

(** Returns the data type for rationals in the given env. *)
external msat_get_rational_type : msat_env -> msat_type = "wrapper_msat_get_rational_type"

(** Returns the data type for integers in the given env. *)
external msat_get_integer_type : msat_env -> msat_type = "wrapper_msat_get_integer_type"

(** Returns a function type in the given env. *)
external msat_get_function_type : msat_env -> msat_type list -> msat_type -> msat_type = "wrapper_msat_get_function_type"

(** Checks whether the given type is bool. *)
external msat_is_bool_type : msat_env -> msat_type -> bool = "wrapper_msat_is_bool_type"

(** Checks whether the given type is rat. *)
external msat_is_rational_type : msat_env -> msat_type -> bool = "wrapper_msat_is_rational_type"

(** Checks whether the given type is int. *)
external msat_is_integer_type : msat_env -> msat_type -> bool = "wrapper_msat_is_integer_type"

(** Declares a new uninterpreted function/constant *)
external msat_declare_function : msat_env -> string -> msat_type -> msat_decl = "wrapper_msat_declare_function"

(** {2 Term creation} *)

(** Returns a term representing logical truth. *)
external msat_make_true : msat_env -> msat_term = "wrapper_msat_make_true"

(** Returns a term representing logical falsity *)
external msat_make_false : msat_env -> msat_term = "wrapper_msat_make_false"

(** Returns a term representing the equivalence of [t1] and [t2]. *)
external msat_make_iff : msat_env -> msat_term -> msat_term -> msat_term = "wrapper_msat_make_iff"

(** Returns a term representing the logical OR of [t1] and [t2]. *)
external msat_make_or : msat_env -> msat_term -> msat_term -> msat_term = "wrapper_msat_make_or"

(** Returns a term representing the logical AND of [t1] and [t2]. *)
external msat_make_and : msat_env -> msat_term -> msat_term -> msat_term = "wrapper_msat_make_and"

(** Returns a term representing the logical negation of [t1]. *)
external msat_make_not : msat_env -> msat_term -> msat_term = "wrapper_msat_make_not"

(** Returns a term representing the equivalence of [t1] and [t2].
    
    If [t1] and [t2] have type [MSAT_BOOL], this is equivalent to [make_iff t1
    t2]. Otherwise, the atom [t1 = t2] is returned. *)
external msat_make_equal : msat_env -> msat_term -> msat_term -> msat_term = "wrapper_msat_make_equal"

(** Returns an atom representing [t1 <= t2].

    The arguments must have the same type. The exception is for integer
    numbers, which can be casted to rational if necessary.  *)
external msat_make_leq : msat_env -> msat_term -> msat_term -> msat_term = "wrapper_msat_make_leq"

(** Returns an expression representing [t1 + t2].

    The arguments must have the same type. The exception is for integer
    numbers, which can be casted to rational if necessary.  *)
external msat_make_plus : msat_env -> msat_term -> msat_term -> msat_term = "wrapper_msat_make_plus"

(** Returns an expression representing [t1 * t2].

    The arguments must have the same type, with the usual exception for
    integer numbers. Moreover, at least one of them must be a number. *)
external msat_make_times : msat_env -> msat_term -> msat_term -> msat_term = "wrapper_msat_make_times"

(** Returns an expression representing [floor t] *)
external msat_make_floor : msat_env -> msat_term -> msat_term = "wrapper_msat_make_floor"

(** Returns an expression representing an integer or rational number. *)
external msat_make_number : msat_env -> string -> msat_term = "wrapper_msat_make_number"

(** Returns an expression representing a term if-then-else construct.

    The two arguments [tt] and [te] must have compatible types. *)
external msat_make_term_ite : msat_env -> msat_term -> msat_term -> msat_term -> msat_term = "wrapper_msat_make_term_ite"

(** Creates a constant from a declaration. *)
external msat_make_constant : msat_env -> msat_decl -> msat_term = "wrapper_msat_make_constant"

(** Creates an uninterpreted function application. *)
external msat_make_uf : msat_env -> msat_decl -> msat_term list -> msat_term = "wrapper_msat_make_uf"

(** Creates a term in [e] from an equivalent term [t] that was created in
    [src]. *)
external msat_make_copy_from : msat_env -> msat_term -> msat_env = "wrapper_msat_make_copy_from"

(** {2 Term access and navigation} *)

(** Returns a numeric identifier for [t].
    
    The returned value is guaranteed to be unique within the environment in
    which [t] was defined. Therefore, it can be used to test two terms for
    equality, as well as a hash value. *)
external msat_term_id : msat_term -> size_t = "wrapper_msat_term_id"

(** Returns the arity of [t]. *)
external msat_term_arity : msat_term -> size_t = "wrapper_msat_term_arity"

(** Returns the nth argument of [t]. *)
external msat_term_get_arg : msat_term -> size_t -> msat_term = "wrapper_msat_term_get_arg"

(** Return a list of all the children of a term (in order) *)
val msat_term_children : msat_term -> msat_term list

(** Returns the type of [t]. *)
external msat_term_get_type : msat_term -> msat_type = "wrapper_msat_term_get_type"


(** Checks whether [t] is the TRUE term. *)
external msat_term_is_true : msat_env -> msat_term -> bool = "wrapper_msat_term_is_true"

(** Checks whether [t] is the FALSE term. *)
external msat_term_is_false : msat_env -> msat_term -> bool = "wrapper_msat_term_is_false"

(** Checks whether [t] is a boolean constant. *)
external msat_term_is_boolean_constant : msat_env -> msat_term -> bool = "wrapper_msat_term_is_boolean_constant"

(** Checks whether [t] is an uninterpreted function application. *)
external msat_term_is_uf : msat_env -> msat_term -> bool = "wrapper_msat_term_is_uf"

(** Checks whether [t] is an atom. *)
external msat_term_is_atom : msat_env -> msat_term -> bool = "wrapper_msat_term_is_atom"

(** Checks whether [t] is a number. *)
external msat_term_is_number : msat_env -> msat_term -> bool = "wrapper_msat_term_is_number"

(* Converts the given term to an [Mpq.t] rational number.
 
    The term must be a number, otherwise an error is reported. *)
val msat_term_to_number : msat_env -> msat_term -> Mpq.t

(** Checks whether [t] is an AND. *)
external msat_term_is_and : msat_env -> msat_term -> bool = "wrapper_msat_term_is_and"

(** Checks whether [t] is an OR. *)
external msat_term_is_or : msat_env -> msat_term -> bool = "wrapper_msat_term_is_or"

(** Checks whether [t] is a NOT. *)
external msat_term_is_not : msat_env -> msat_term -> bool = "wrapper_msat_term_is_not"

(** Checks whether [t] is an equivalence vetween boolean terms. *)
external msat_term_is_iff : msat_env -> msat_term -> bool = "wrapper_msat_term_is_iff"

(** Checks whether [t] is a constant. *)
external msat_term_is_constant : msat_env -> msat_term -> bool = "wrapper_msat_term_is_constant"

(** Checks whether [t] is an equality. *)
external msat_term_is_equal : msat_env -> msat_term -> bool = "wrapper_msat_term_is_equal"

(** Checks whether [t] is a [t1 <= t2] atom. *)
external msat_term_is_leq : msat_env -> msat_term -> bool = "wrapper_msat_term_is_leq"

(** Checks whether [t] is a [t1 + t2] expression. *)
external msat_term_is_plus : msat_env -> msat_term -> bool = "wrapper_msat_term_is_plus"

(** Checks whether [t] is a [t1 * t2] expression. *)
external msat_term_is_times : msat_env -> msat_term -> bool = "wrapper_msat_term_is_times"

(** Checks whether [t] is a term if-then-else. *)
external msat_term_is_term_ite : msat_env -> msat_term -> bool = "wrapper_msat_term_is_term_ite"

(** Checks whether [t] is a [floor t1] expression. *)
external msat_term_is_floor : msat_env -> msat_term -> bool = "wrapper_msat_term_is_floor"

(** Returns the declaration of the given [symbol] in the given
    environment (if any)
 
    If [symbol] is not declared in [e], the returned value [ret] will be s.t.
    MSAT_ERROR_DECL(ret) is true. *)
external msat_find_decl : msat_env -> string -> msat_decl = "wrapper_msat_find_decl"

(** Returns the declaration associated to [t] (if any)
    
    If [t] is not a constant or a function application, the returned value
    [ret] will be s.t. MSAT_ERROR_DECL(ret) is true *)
external msat_term_get_decl : msat_term -> msat_decl = "wrapper_msat_term_get_decl"

(** Returns a numeric identifier for the input declaration
 
    The returned value is guaranteed to be unique within the environment in
    which [d] was defined. Therefore, it can be used to test
    two declarations for equality, as well as a hash value. *)
external msat_decl_id : msat_decl -> size_t = "wrapper_msat_decl_id"

val msat_term_equal : msat_term -> msat_term -> bool
val msat_term_compare : msat_term -> msat_term -> int

(** {2 Term parsing/printing} *)

(** Creates a term from its string representation.

    The syntax of [repr] is that of the SMT-LIB v2. All the variables and
    functions must have been previously declared in [e] *)
external msat_from_string : msat_env -> string -> msat_term = "wrapper_msat_from_string"

(** Creates a term from a string in SMT-LIB v2 format. *)
external msat_from_smtlib2 : msat_env -> string -> msat_term = "wrapper_msat_from_smtlib2"

(** Converts the given [term] to SMT-LIB v2 format. *)
external msat_to_smtlib2 : msat_env -> msat_term -> string = "wrapper_msat_to_smtlib2"

(** {2 Problem solving } *)

(** Pushes a checkpoint for backtracking in an environment. *)
val msat_push_backtrack_point : msat_env -> unit

(** Backtracks to the last checkpoint set in the environment [e]. *)
val msat_pop_backtrack_point : msat_env -> unit

(** Returns the number of backtrack points in the given environment *)
external msat_num_backtrack_points : msat_env -> size_t = "wrapper_msat_num_backtrack_points"

(** Resets an environment.

    Clears the assertion stack (see [!msat_assert_formula],
    [!msat_push_backtrack_point], [!msat_pop_backtrack_point] of [e].  However,
    terms created in [e] are still valid. *)
val msat_reset_env : msat_env -> unit

(** Adds a logical formula to an environment. *)
val msat_assert_formula : msat_env -> msat_term -> unit

(** Checks the satisfiability of the given environment.

    Checks the satisfiability of the conjunction of all the formulas asserted
    in [e] (see [!msat_assert_formula]). Before calling this function, the
    right theory solvers must have been enabled (see [!msat_add_theory]). *)
val msat_solve : msat_env -> msat_result

(** {2 Interpolation} *)

(** Creates a new group for interpolation. 

    When computing an interpolant, formulas are organized into several groups,
    which are partitioned into two sets GA and GB. The conjuction of formulas in
    GA will play the role of A, and that of formulas in GB will play the role of
    B (see [!msat_set_itp_group], [!msat_get_interpolant]). *)
external msat_create_itp_group : msat_env -> int = "wrapper_msat_create_itp_group"

(** Sets the current interpolation group.

    All the formulas asserted after this call (with [!msat_assert_formula])
    will belong to [group]. *)
val msat_set_itp_group : msat_env -> int -> unit

(** Computes an interpolant for a pair [(A, B)] of formulas.

    [A] is the conjunction of all the assumed formulas in the [groups_of_a]
    groups (see [!msat_create_itp_group]), and [B] is the rest of assumed
    formulas.

    This function must be called only after [!msat_solve], and only if
    [MSAT_UNSAT] was returned. Moreover, interpolation must have been enabled in
    the configuration for the environment *)
external msat_get_interpolant : msat_env -> int list -> msat_term = "wrapper_msat_get_interpolant"


(** {2 Model computation} *)

(** Returns the value of the term term in the current model. Preconditions:
- model computation was enabled in the configuration of the environment
- the last call to [!msat_solve] returned a [MSAT_SAT] result
- no assert/push/pop/allsat commands have been issued in the meantime *)
external msat_get_model_value : msat_env -> msat_term -> msat_term = "wrapper_msat_get_model_value"

(** Creates a model object. *)
external msat_get_model : msat_env -> msat_model = "wrapper_msat_get_model"

(** Destroys the given model object. *)
external msat_destroy_model : msat_model -> unit = "wrapper_msat_destroy_model"

(** Evaluates the input term in the given model. *)
external msat_model_eval : msat_model -> msat_term -> msat_term = "wrapper_msat_model_eval"

val msat_destruct : msat_env -> msat_term ->
  [ `Tru
  | `Fls
  | `Real of Mpq.t
  | `Add of msat_term list
  | `Mul of msat_term list
  | `Unop of [`Floor] * msat_term
  | `Atom of [`Eq | `Leq] * msat_term * msat_term
  | `And of msat_term list
  | `Or of msat_term list
  | `Not of msat_term
  | `Iff of msat_term * msat_term
  | `Ite of msat_term * msat_term * msat_term
  | `App of msat_decl * (msat_term list) ]
