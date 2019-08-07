module MultiFEBases

using Gridap
using Gridap.Helpers

import Gridap: gradient
import Gridap: inner
import Base: +, -, *
import Base: length, getindex
import Gridap.FESpaces: FEBasis
import Gridap: CellBasis
import Gridap: restrict

struct FEBasisWithFieldId{B<:CellBasis}
  cellbasis::B
  fieldid::Int
end

function CellBasis(
  trian::Triangulation{D,Z},
  fun::Function,
  b::FEBasisWithFieldId,
  u::Vararg{<:CellField{Z}}) where {D,Z}
  basis = CellBasis(trian,fun,b.cellbasis,u...)
  FEBasisWithFieldId(basis,b.fieldid)
end

for op in (:+, :-, :(gradient))
  @eval begin
    function ($op)(a::FEBasisWithFieldId)
      FEBasisWithFieldId($op(a.cellbasis),a.fieldid)
    end
  end
end

for op in (:+, :-, :*)
  @eval begin
    function ($op)(a::FEBasisWithFieldId,b::CellMap)
      FEBasisWithFieldId($op(a.cellbasis,b),a.fieldid)
    end
    function ($op)(a::CellMap,b::FEBasisWithFieldId)
      FEBasisWithFieldId($op(a,b.cellbasis),b.fieldid)
    end
  end
end

function inner(a::FEBasisWithFieldId,b::CellField)
  block = varinner(a.cellbasis,b)
  blocks = [block,]
  fieldids = [(a.fieldid,),]
  MultiCellMap(blocks,fieldids)
end

function inner(a::FEBasisWithFieldId,b::FEBasisWithFieldId)
  block = varinner(a.cellbasis,b.cellbasis)
  blocks = [block,]
  fieldids = [(a.fieldid,b.fieldid),]
  MultiCellMap(blocks,fieldids)
end

struct MultiFEBasis
  blocks::Vector{<:FEBasisWithFieldId}
end

function FEBasis(mfes::MultiFESpace)
  blocks = [ FEBasisWithFieldId(CellBasis(v),i) for (i,v) in enumerate(mfes) ]
  MultiFEBasis(blocks)
end

length(mfb::MultiFEBasis) = length(mfb.blocks)

getindex(mfb::MultiFEBasis,i::Integer) = mfb.blocks[i]

function restrict(mfeb::MultiFEBasis,trian::BoundaryTriangulation)
  blocks = [
    FEBasisWithFieldId(restrict(feb.cellbasis,trian),feb.fieldid)
    for feb in mfeb.blocks ]
  MultiFEBasis(blocks)
end

function restrict(feb::MultiFEBasis,trian::SkeletonTriangulation)
  @notimplemented
  # We still need to create a MultiSkeletonPair
end


end # module MultiFEBases
