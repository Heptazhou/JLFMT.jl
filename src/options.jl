Base.@kwdef struct Options
    indent::Int = 4
    margin::Int = 92
    always_for_in::Union{Bool,Nothing} = true
    whitespace_typedefs::Bool = true
    whitespace_ops_in_indices::Bool = false
    remove_extra_newlines::Bool = false
    import_to_using::Bool = true
    pipe_to_function_call::Bool = false
    short_to_long_function_def::Bool = false
    always_use_return::Bool = false
    whitespace_in_kwargs::Bool = true
    annotate_untyped_fields_with_any::Bool = true
    format_docstrings::Bool = false
    align_struct_field::Bool = true
    align_assignment::Bool = true
    align_conditional::Bool = true
    align_pair_arrow::Bool = true
    conditional_to_if::Bool = false
    normalize_line_endings::String = "unix"
    align_matrix::Bool = true
    join_lines_based_on_source::Bool = false
    trailing_comma::Union{Bool,Nothing} = true
    indent_submodule::Bool = true
    separate_kwargs_with_semicolon::Bool = false
    surround_whereop_typeparameters::Bool = false
end

function needs_alignment(opts::Options)
    opts.align_struct_field ||
        opts.align_conditional ||
        opts.align_assignment ||
        opts.align_pair_arrow ||
        opts.align_matrix
end
