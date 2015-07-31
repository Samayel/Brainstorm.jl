export
    validated_setdiff!

validated_setdiff!(set, subset) = begin
    length(subset) == length(unique(subset)) || return false
    subset ⊆ set || return false

    setdiff!(set, subset)
    true
end
