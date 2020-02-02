################################################################
"""
    head, body = unwrap_fun(fexpr)
    fargs, wherestack, body = unwrap_fun(fexpr,true)
    f, args, wherestack, body = unwrap_fun(fexpr, true, true)

Unwraps function expression.
"""
function unwrap_fun(expr::Expr)
    if expr.head in (:function, :(=))
        fexpr = expr
    elseif expr.head == :block
        fexpr = expr.args[2] # separate fexpr from block
    else
        error("expression not supported")
    end

    head = fexpr.args[1]
    body = fexpr.args[2]
    return head, body
end

function unwrap_fun(expr::Expr, should_unwrap_head::Bool)
    if expr.head in (:function, :(=))
        fexpr = expr
    elseif expr.head == :block
        fexpr = expr.args[2] # separate fexpr from block
    else
        error("expression not supported")
    end

    head = fexpr.args[1]
    fargs, wherestack = unwrap_head(head)
    body = fexpr.args[2]
    return fargs, wherestack, body
end

function unwrap_fun(expr::Expr, should_unwrap_head::Bool, should_unwrap_fargs::Bool)
    if expr.head in (:function, :(=))
        fexpr = expr
    elseif expr.head == :block
        fexpr = expr.args[2] # separate fexpr from block
    else
        error("expression not supported")
    end

    head = fexpr.args[1]
    fargs, wherestack = unwrap_head(head)
    f, args = unwrap_fargs(fargs)

    body = fexpr.args[2]
    return f, args, wherestack, body
end
################################################################
"""
    fexpr = wrap_fun(f, args, wherestack, body)
    fexpr = wrap_fun(fargs, wherestack, body)
    fexpr = wrap_fun(head, body)
    fexpr = wrap_fun(fexpr)

Returns a function definition expression
"""
function wrap_fun(f, args, wherestack, body)
    fargs = wrap_fargs(f, args)
    head =  wrap_where(fargs, wherestack)
    return Expr(:function, head, Expr(:block, body))
end

function wrap_fun(fargs, wherestack, body)
    head =  wrap_where(fargs, wherestack)
    return Expr(:function, head, Expr(:block, body))
end

function wrap_fun(head::Expr, body::Expr)
    return Expr(:function, head, Expr(:block, body))
end

function wrap_fun(fexpr::Expr)
    if fexpr.head in (:function, :(=))
        return fexpr
    elseif fexpr.head == :block
        fexpr = fexpr.args[2] # separate fexpr from block
        return fexpr
    else
        error("expression not supported")
    end
end

################################################################
