export
    validated_setdiff!

validated_setdiff!(set, subset) = begin
    subset == unique(subset) || return false
    subset ⊆ set || return false

    setdiff!(set, subset)
    true
end
