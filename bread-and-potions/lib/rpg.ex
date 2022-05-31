defmodule RPG do
  defmodule Character do
    defstruct health: 100, mana: 0

    # @type t :: %__MODULE__{
    #   health: number,
    #   mana: number
    # }
  end

  defmodule LoafOfBread do
    defstruct []
  end

  defmodule ManaPotion do
    defstruct strength: 10
  end

  defmodule Poison do
    defstruct []
  end

  defmodule EmptyBottle do
    defstruct []
  end

  # Add code to define the protocol and its implementations below here...

  defprotocol Edible do
    @doc """
    Modifies character according to edible behavior.
    """

    # @type edibles() :: LoafOfBread | ManaPotion | Poison

    # @spec eat(edibles(), Character) :: {nil | EmptyBottle, Character}
    def eat(item, character)
  end

  defimpl Edible, for: LoafOfBread do
    def eat(_loaf, %Character{health: health} = character) do
      {nil, %Character{character | health: health + 5}}
    end
  end

  defimpl Edible, for: ManaPotion do
    def eat(%ManaPotion{strength: strength}, %Character{mana: mana} = character) do
      {%EmptyBottle{}, %Character{character | mana: mana + strength}}
    end
  end

  defimpl Edible, for: Poison do
    def eat(%Poison{} = _poison, %Character{} = character) do
      {%EmptyBottle{}, %Character{character | health: 0}}
    end
  end
end
