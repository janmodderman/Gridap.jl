"""
FE Function
"""
abstract type FEFunction{D,Z,T,E} end

free_dofs(::FEFunction) = @abstractmethod
fixed_dofs(::FEFunction) = @abstractmethod
# @santiagobadia : Do we want to make a difference between Dirichlet and constrained ?

struct ConformingFEFunction{
        D,Z,T,E,
        A<:FESpace{D,Z,T,E},
        B<:CellFieldFromExpand{D,T,<:CellBasis{D},<:CellVectorFromLocalToGlobalPosAndNeg}} <: FEFunction{D,Z,T,E}
	fesp::A
	dof_values::B
end

free_dofs(this::ConformingFEFunction) = this.dof_values.coeffs.gid_to_val_pos
fixed_dofs(this::ConformingFEFunction) = this.dof_values.coeffs.gid_to_val_neg