defmodule Puppies.EmailInContentTest do
  use ExUnit.Case
  # doctest EmailInContent

  alias Puppies.EmailInContent

  describe "Scan content for emails" do
    test "gets a list of emails" do
      data = test_data(["not@user.email", "test@test.com", "test@test.org"])
      res = EmailInContent.get_emails_in_content(data)
      assert(res != [])
    end

    test "gets a empty list" do
      data = test_data(["word"])
      res = EmailInContent.get_emails_in_content(data)
      assert(res == [])
    end

    test "returns a flag for a user that uses an email in their conteant that is not their own" do
      data = test_data(["not@user.email", "test@test.com", "test@test.org"])

      res = EmailInContent.content_contains_email_not_associated_to_user(data, "test@test.org")

      assert(res == true)
    end

    test "doesn't return a flag" do
      data = test_data(["test.org", "test at test doc org", "test@test.org"])

      res = EmailInContent.content_contains_email_not_associated_to_user(data, "test@test.org")

      assert(res == false)
    end

    def test_data(emails) do
      "#{Enum.join(emails, ", ")} Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Fermentum leo vel orci porta non pulvinar neque laoreet suspendisse. Nisi scelerisque eu ultrices vitae. Vitae semper quis  nulla at volutpat. Commodo quis imperdiet massa tincidunt. Quam adipiscing vitae proin sagittis nisl rhoncus mattis rhoncus. Massa ultricies mi quis hendrerit dolor magna eget est. Elementum nisi quis eleifend quam adipiscing vitae. Tellus in hac habitasse platea dictumst vestibulum rhoncus. Neque laoreet suspendisse interdum consectetur libero id faucibus. Eu feugiat pretium nibh ipsum consequat nisl vel. Ultrices dui sapien eget mi proin sed libero enim. Nulla aliquet enim tortor at. Enim nunc faucibus a pellentesque sit. Interdum consectetur libero id faucibus nisl tincidunt eget nullam non. Nec tincidunt praesent semper feugiat nibh sed pulvinar proin. Adipiscing tristique risus nec feugiat in fermentum posuere urna nec. Id faucibus nisl tincidunt eget. Varius quam quisque id diam vel quam elementum pulvinar etiam. Posuere sollicitudin aliquam ultrices sagittis orci. Purus faucibus ornare suspendisse sed nisi lacus sed. Elementum sagittis vitae et leo duis ut diam quam. Nam aliquam sem et tortor consequat id porta nibh. Risus viverra adipiscing at in tellus integer feugiat scelerisque. Sed vulputate odio ut enim blandit. Elit eget gravida cum sociis natoque penatibus et magnis. Sed vulputate odio ut enim blandit volutpat maecenas volutpat. Faucibus nisl tincidunt eget nullam non nisi. Risus ultricies tristique nulla aliquet enim. Turpis tincidunt id aliquet risus. Enim sed faucibus turpis in eu mi bibendum neque egestas. Mattis vulputate enim nulla aliquet porttitor lacus luctus. Ultrices vitae auctor eu augue ut lectus. Suspendisse ultrices gravida dictum fusce ut placerat orci. Urna et pharetra pharetra massa massa ultricies. Ac tortor vitae purus faucibus ornare. Vitae auctor eu augue ut lectus arcu bibendum at varius. Est ante in nibh mauris. Pretium fusce id velit ut tortor pretium viverra. Ultrices neque ornare aenean euismod elementum nisi quis eleifend. Faucibus et molestie ac feugiat sed lectus vestibulum mattis ullamcorper. Turpis massa tincidunt dui ut ornare lectus sit. Rhoncus mattis rhoncus urna neque viverra. Mi in nulla posuere sollicitudin aliquam ultrices sagittis. Amet facilisis magna etiam tempor orci.Sed adipiscing diam donec adipiscing tristique risus nec feugiat. Et netus et malesuada fames ac turpis. Tellus orci ac auctor augue mauris augue neque. Elementum nisi quis eleifend quam adipiscing. Ut tortor pretium viverra suspendisse potenti nullam. Id aliquet risus feugiat in ante. Lacus vel facilisis volutpat est velit egestas dui. Porttitor lacus luctus accumsan tortor. Sed risus ultricies tristique nulla aliquet. Elit scelerisque mauris pellentesque pulvinar. Fringilla ut morbi tincidunt augue interdum velit euismod. Aliquam sem fringilla ut morbi tincidunt augue interdum velit. In tellus integer feugiat scelerisque varius. Faucibus nisl tincidunt eget nullam non nisi. Ullamcorper velit sed ullamcorper morbi tincidunt ornare massa. Placerat in egestas erat imperdiet. Sed augue lacus viverra vitae. Porttitor massa id neque aliquam vestibulum morbi blandit cursus risus. Quis lectus nulla at volutpat diam ut venenatis tellus in. Et odio pellentesque diam volutpat commodo sed egestas egestas fringilla. Nibh venenatis cras sed felis eget. Orci eu lobortis elementum nibh tellus. Enim blandit volutpat maecenas volutpat blandit aliquam etiam erat. Massa massa ultricies mi quis hendrerit dolor. Nunc consequat interdum varius sit. Vitae auctor eu augue ut lectus. Et leo duis ut diam quam nulla porttitor. Eget sit amet tellus cras adipiscing enim eu. Vitae proin sagittis nisl rhoncus mattis rhoncus urna. Venenatis cras sed felis eget velit aliquet sagittis id. Vestibulum sed arcu non odio euismod lacinia at quis risus. Risus viverra adipiscing at in tellus. Maecenas ultricies mi eget mauris pharetra et ultrices."
    end
  end
end
