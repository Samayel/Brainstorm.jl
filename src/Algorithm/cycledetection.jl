export cycle_detection_floyd, cycle_detection_brent

# https://en.wikipedia.org/wiki/Cycle_detection#Algorithms

cycle_detection_floyd(f, x0) = begin
    # Main phase of algorithm: finding a repetition x_i = x_2i.
    # The hare moves twice as quickly as the tortoise and
    # the distance between them increases by 1 at each step.
    # Eventually they will both be inside the cycle and then,
    # at some point, the distance between them will be
    # divisible by the period λ.
    tortoise = f(x0) # f(x0) is the element/node next to x0.
    hare = (f ∘ f)(x0)
    while tortoise ≠ hare
        tortoise = f(tortoise)
        hare = (f ∘ f)(hare)
    end

    # At this point the tortoise position, ν, which is also equal
    # to the distance between hare and tortoise, is divisible by
    # the period λ. So hare moving in circle one step at a time, 
    # and tortoise (reset to x0) moving towards the circle, will 
    # intersect at the beginning of the circle. Because the 
    # distance between them is constant at 2ν, a multiple of λ,
    # they will agree as soon as the tortoise reaches index μ.

    # Find the position μ of first repetition.    
    μ = 0
    tortoise = x0
    while tortoise ≠ hare
        tortoise = f(tortoise)
        hare = f(hare)   # Hare and tortoise move at same speed
        μ += 1
    end

    # Find the length of the shortest cycle starting from x_μ
    # The hare moves one step at a time while tortoise is still.
    # λ is incremented until λ is found.
    λ = 1
    hare = f(tortoise)
    while tortoise ≠ hare
        hare = f(hare)
        λ += 1
    end

    λ, μ
end

cycle_detection_brent(f, x0) = begin
    # main phase: search successive powers of two
    power = λ = 1
    tortoise = x0
    hare = f(x0)  # f(x0) is the element/node next to x0.
    while tortoise ≠ hare
        if power == λ  # time to start a new power of two?
            tortoise = hare
            power *= 2
            λ = 0
        end
        hare = f(hare)
        λ += 1
    end

    # Find the position of the first repetition of length λ
    μ = 0
    tortoise = hare = x0
    for i in 0:λ-1
        hare = f(hare)
    end
    # The distance between the hare and tortoise is now λ.

    # Next, the hare and tortoise move at same speed until they agree
    while tortoise ≠ hare
        tortoise = f(tortoise)
        hare = f(hare)
        μ += 1
    end

    λ, μ
end
