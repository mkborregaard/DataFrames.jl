module TestShow
    using DataFrames
    using Compat
    import Compat.String
    df = DataFrame(A = 1:3, B = ["x", "y", "z"])

    io = IOBuffer()
    show(io, df)
    show(io, df, true)
    showall(io, df)
    showall(io, df, true)

    subdf = sub(df, [2, 3]) # df[df[:A] .> 1.0, :]
    show(io, subdf)
    show(io, subdf, true)
    showall(io, subdf)
    showall(io, subdf, true)

    if VERSION > v"0.5-"
        using Juno
        out = DataFrames._render(df)
        @assert out.head.xs[1] == DataFrame
        @assert isa(out.children()[1], Juno.Table)
        @assert size(out.children()[1].xs) == (4, 2)
    end

    dfvec = DataFrame[df for _=1:3]
    show(io, dfvec)
    showall(io, dfvec)

    gd = groupby(df, :A)
    show(io, gd)
    showall(io, gd)

    dfr = DataFrameRow(df, 1)
    show(io, dfr)

    df = DataFrame(A = Array(String, 3))

    A = DataFrames.StackedVector(Any[[1, 2, 3], [4, 5, 6], [7, 8, 9]])
    show(io, A)
    A = DataFrames.RepeatedVector([1, 2, 3], 5, 1)
    show(io, A)
    A = DataFrames.RepeatedVector([1, 2, 3], 1, 5)
    show(io, A)

end
