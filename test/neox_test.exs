defmodule NeoxTest do
  defmodule Store do
    defstruct name: nil, description: nil
  end

  import Neox.Query
  use ExUnit.Case

  test "the truth" do
    create(store: %Store{name: "Custom Store"})
    |> flush


    # match(store: %Store{name: "Custom Store"})
    # |> delete(:store)

    # DROP CONSTRAINT ON (book:Book) ASSERT book.isbn IS UNIQUE

    #drop_constraint(store: %Store{}) assert store.name is unique

    # create(%{john: %User{name: "john"}})
    # |> create(%{marie: %User{name: "marie"}})
    # |> return(:john)

    # create(%{marie: %{User{name: "John"}}})
    # |> return(:marie)

    # match({john: %{User{name: "John"}}, marie: %{User{name: "Marie"}}})
    # |> create_unique(:john, -%{Married}->, :marie)

    # match({me: %{User}})
    # |> return
  end
end
