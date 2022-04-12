using JuliaFormatter
using JuliaFormatter: DefaultStyle, YASStyle, Options, options, CONFIG_FILE_NAME
using CSTParser
using Test

import JuliaFormatter: options
function options(s::DefaultStyle)
    return (;
        indent = 4,
        margin = 92,
        always_for_in = false,
        whitespace_typedefs = false,
        whitespace_ops_in_indices = false,
        remove_extra_newlines = false,
        import_to_using = false,
        pipe_to_function_call = false,
        short_to_long_function_def = false,
        always_use_return = false,
        whitespace_in_kwargs = true,
        annotate_untyped_fields_with_any = true,
        format_docstrings = false,
        align_struct_field = false,
        align_assignment = false,
        align_conditional = false,
        align_pair_arrow = false,
        conditional_to_if = false,
        normalize_line_endings = "auto",
        align_matrix = false,
        join_lines_based_on_source = false,
        trailing_comma = true,
        indent_submodule = false,
        separate_kwargs_with_semicolon = false,
    )
end
function DefaultOption(; margin = 92)
    Options(4, margin, false, false, false, false, false, false, false, false, true, true, false, false, false, false, false, false, "auto", false, false, true, false, false)
end

fmt1(s; i = 4, m = 80, kwargs...) =
    JuliaFormatter.format_text(s; kwargs..., indent = i, margin = m)
fmt1(s, i, m; kwargs...) = fmt1(s; kwargs..., i = i, m = m)

# Verifies formatting the formatted text
# results in the same output
function fmt(s; i = 4, m = 80, kwargs...)
    kws = merge(options(DefaultStyle()), kwargs)
    s1 = fmt1(s; kws..., i = i, m = m)
    return fmt1(s1; kws..., i = i, m = m)
end
fmt(s, i, m; kwargs...) = fmt(s; kwargs..., i = i, m = m)

yasfmt1(str; kwargs...) =
    fmt1(str; style = YASStyle(), options(DefaultStyle())..., kwargs...)
yasfmt(str; i = 4, m = 80, kwargs...) =
    fmt(str; i = i, m = m, style = YASStyle(), kwargs...)
yasfmt(str, i::Int, m::Int; kwargs...) = yasfmt(str; i = i, m = m, kwargs...)

bluefmt1(str) = fmt1(str; style = BlueStyle(), options(DefaultStyle())...)
bluefmt(str; i = 4, m = 80, kwargs...) =
    fmt(str; i = i, m = m, style = BlueStyle(), kwargs...)
bluefmt(str, i::Int, m::Int; kwargs...) = bluefmt(str; i = i, m = m, kwargs...)

function run_pretty(text::String; style = DefaultStyle(), opts = DefaultOption())
    d = JuliaFormatter.Document(text)
    s = JuliaFormatter.State(d, opts)
    x = CSTParser.parse(text, true)
    t = JuliaFormatter.pretty(style, x, s)
    t
end
run_pretty(text::String, margin::Int) = run_pretty(text, opts = DefaultOption(margin = margin))

function run_nest(text::String; opts = DefaultOption(), style = DefaultStyle())
    d = JuliaFormatter.Document(text)
    s = JuliaFormatter.State(d, opts)
    x = CSTParser.parse(text, true)
    t = JuliaFormatter.pretty(style, x, s)
    JuliaFormatter.nest!(style, t, s)
    t, s
end
run_nest(text::String, margin::Int) = run_nest(text, opts = DefaultOption(margin = margin))

function run_format(text::String; style = DefaultStyle(), opts = DefaultOption())
    d = JuliaFormatter.Document(text)
    s = JuliaFormatter.State(d, opts)
    cst = CSTParser.parse(text, true)
    JuliaFormatter.format_text(cst, style, s)
    s
end

@testset "JuliaFormatter" begin
    include("default_style.jl")
    include("yas_style.jl")
    include("blue_style.jl")
    include("sciml_style.jl")
    include("issues.jl")
    include("options.jl")
    include("document.jl")
    include("interface.jl")
    include("config.jl")
    include("format_repo.jl")
end
