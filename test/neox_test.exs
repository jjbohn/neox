defmodule NeoxTest do
  import Neox.Query
  use ExUnit.Case

  setup do
    create(john: %User{name: "John", email: "jjbohn@gmail.com"},
           marie: %User{name: "Marie", email: "mimimmartin@gmail.com"})
    |> flush

    on_exit fn ->
      match(users: %User{})
      |> delete(:users)
    end
  end

  test "basic node create" do
    users = match(users: %User{})
            |> return(:users)

    assert Enum.count(users) == 2

    assert List.first(users) == %User{name: "John", email: "jjbohn@gmail.com"}
    assert List.last(users) == %User{name: "Marie", email: "mimimmartin@gmail.com"}
  end

  test "single node retrieval" do
    john = match(john: %User{})
            |> return(:john)
            |> List.first

    assert john == %User{name: "John", email: "jjbohn@gmail.com"}
  end

  test "relationship creation" do
    # match(john: %User{name: "John"})
    # |> match(john: %User{name: "Marie"})
  end
end
