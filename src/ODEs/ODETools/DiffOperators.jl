"""
Define the time derivative operator for a function f(x, t)
- time_derivative(f)   : (x, t) -> ∂tf(x, t)
- time_derivative(f, x):     t  -> ∂tf(x, t)
- time_derivative(f, t):     x  -> ∂tf(x, t)
"""
function time_derivative(f::Function)
  function time_derivative_f(x, t)
    fxt = zero(return_type(f, x, t))
    _time_derivative_f(f, x, t, fxt)
  end
  time_derivative_f(x::VectorValue) = t -> time_derivative_f(x, t)
  time_derivative_f(t) = x -> time_derivative_f(x, t)
end

const ∂t = time_derivative

function _time_derivative_f(f, x, t, fxt)
  ForwardDiff.derivative(t -> f(x, t), t)
end

function _time_derivative_f(f, x, t, fxt::VectorValue)
  VectorValue(ForwardDiff.derivative(t -> get_array(f(x, t)), t))
  # VectorValue(ForwardDiff.derivative(t->f(x,t),t))
end

function _time_derivative_f(f, x, t, fxt::TensorValue)
  TensorValue(ForwardDiff.derivative(t -> get_array(f(x, t)), t))
end

"""
Define the second-order time derivative operator for a function f(x, t)
recursively
"""
∂tt(f::Function) = ∂t(∂t(f))
