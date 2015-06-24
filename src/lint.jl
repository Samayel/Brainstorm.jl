macro lintpragma(s)
end

@lintpragma("Ignore undefined module Base.Dates")
@lintpragma("Ignore undefined module DataStructures.SortedDict")
@lintpragma("Ignore undefined module Iterators.drop")
@lintpragma("Ignore undefined module Iterators.imap")
@lintpragma("Ignore undefined module Iterators.take")
@lintpragma("Ignore undefined module Lint.lintpkg")
@lintpragma("Ignore undefined module Pipe.@pipe")
@lintpragma("Ignore undefined module Reexport.@reexport")

@lintpragma("Ignore undefined module Brainstorm.DataStructure.takewhile")
@lintpragma("Ignore undefined module Brainstorm.Math.checked_add")
@lintpragma("Ignore undefined module Brainstorm.Math.checked_sub")

@lintpragma("Ignore use of undeclared variable _")

if VERSION >= v"0.4-"
    @lintpragma("Ignore undefined module Combinatorics")
    @lintpragma("Ignore undefined module Formatting")
    @lintpragma("Ignore undefined module Lazy")
    @lintpragma("Ignore undefined module NamedArrays")

    @lintpragma("Ignore use of undeclared variable nothing")
    @lintpragma("Ignore use of undeclared variable :")
end
