defmodule Phoenix00Web.EmailLiveTest do
  use Phoenix00Web.ConnCase

  import Phoenix.LiveViewTest
  import Phoenix00.MessagesFixtures

  @create_attrs %{status: :pending, to: "some to", from: "some from", aws_message_id: "some aws_message_id", email_id: "some email_id"}
  @update_attrs %{status: :sent, to: "some updated to", from: "some updated from", aws_message_id: "some updated aws_message_id", email_id: "some updated email_id"}
  @invalid_attrs %{status: nil, to: nil, from: nil, aws_message_id: nil, email_id: nil}

  defp create_email(_) do
    email = email_fixture()
    %{email: email}
  end

  describe "Index" do
    setup [:create_email]

    test "lists all emails", %{conn: conn, email: email} do
      {:ok, _index_live, html} = live(conn, ~p"/emails")

      assert html =~ "Listing Emails"
      assert html =~ email.to
    end

    test "saves new email", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("a", "New Email") |> render_click() =~
               "New Email"

      assert_patch(index_live, ~p"/emails/new")

      assert index_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#email-form", email: @create_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/emails")

      html = render(index_live)
      assert html =~ "Email created successfully"
      assert html =~ "some to"
    end

    test "updates email in listing", %{conn: conn, email: email} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("#emails-#{email.id} a", "Edit") |> render_click() =~
               "Edit Email"

      assert_patch(index_live, ~p"/emails/#{email}/edit")

      assert index_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#email-form", email: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/emails")

      html = render(index_live)
      assert html =~ "Email updated successfully"
      assert html =~ "some updated to"
    end

    test "deletes email in listing", %{conn: conn, email: email} do
      {:ok, index_live, _html} = live(conn, ~p"/emails")

      assert index_live |> element("#emails-#{email.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#emails-#{email.id}")
    end
  end

  describe "Show" do
    setup [:create_email]

    test "displays email", %{conn: conn, email: email} do
      {:ok, _show_live, html} = live(conn, ~p"/emails/#{email}")

      assert html =~ "Show Email"
      assert html =~ email.to
    end

    test "updates email within modal", %{conn: conn, email: email} do
      {:ok, show_live, _html} = live(conn, ~p"/emails/#{email}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Email"

      assert_patch(show_live, ~p"/emails/#{email}/show/edit")

      assert show_live
             |> form("#email-form", email: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#email-form", email: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/emails/#{email}")

      html = render(show_live)
      assert html =~ "Email updated successfully"
      assert html =~ "some updated to"
    end
  end
end
