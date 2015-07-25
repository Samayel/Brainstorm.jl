macro lintpragma(s)
end

@lintpragma("Ignore undefined module DataStructures.SortedDict")
@lintpragma("Ignore undefined module Iterators.drop")
@lintpragma("Ignore undefined module Iterators.imap")
@lintpragma("Ignore undefined module Iterators.take")
@lintpragma("Ignore undefined module Lint.lintpkg")
@lintpragma("Ignore undefined module Lists.List")
@lintpragma("Ignore undefined module Lists.ListNode")
@lintpragma("Ignore undefined module TaylorSeries.Taylor1")
@lintpragma("Ignore undefined module TaylorSeries.get_coeff")
@lintpragma("Ignore undefined module TaylorSeries.taylor1_variable")
@lintpragma("Ignore undefined module Pipe.@pipe")
@lintpragma("Ignore undefined module Reexport.@reexport")

@lintpragma("Ignore undefined module Brainstorm.dropwhile")
@lintpragma("Ignore undefined module Brainstorm.flatten")
@lintpragma("Ignore undefined module Brainstorm.takewhile")
@lintpragma("Ignore undefined module Brainstorm.Math.checked_add")
@lintpragma("Ignore undefined module Brainstorm.Math.checked_sub")
@lintpragma("Ignore undefined module Brainstorm.Math.NumberTheory.coefficient")
@lintpragma("Ignore undefined module Brainstorm.Math.NumberTheory.expand_maclaurin_series")
@lintpragma("Ignore undefined module Brainstorm.@anon")

@lintpragma("Ignore use of undeclared variable _")

if VERSION < v"0.4-"
    @lintpragma("Ignore undefined module Base.Dates")
else
    @lintpragma("Ignore undefined module Combinatorics")
    @lintpragma("Ignore undefined module Formatting")
    @lintpragma("Ignore undefined module Lazy")
    @lintpragma("Ignore undefined module NamedArrays")

    @lintpragma("Ignore use of undeclared variable nothing")
    @lintpragma("Ignore use of undeclared variable :")
end
