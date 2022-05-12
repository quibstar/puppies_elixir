defmodule Puppies.BlacklistsTest do
  use Puppies.DataCase

  alias Puppies.Blacklists

  describe "email_blacklists" do
    alias Puppies.Blacklists.EmailBlacklist

    import Puppies.BlacklistsFixtures

    @invalid_attrs %{domain: nil}

    test "list_email_blacklists/0 returns all email_blacklists" do
      email_blacklist = email_blacklist_fixture()
      assert Blacklists.list_email_blacklists() == [email_blacklist]
    end

    test "get_email_blacklist!/1 returns the email_blacklist with given id" do
      email_blacklist = email_blacklist_fixture()
      assert Blacklists.get_email_blacklist!(email_blacklist.id) == email_blacklist
    end

    test "create_email_blacklist/1 with valid data creates a email_blacklist" do
      valid_attrs = %{domain: "some domain"}

      assert {:ok, %EmailBlacklist{} = email_blacklist} = Blacklists.create_email_blacklist(valid_attrs)
      assert email_blacklist.domain == "some domain"
    end

    test "create_email_blacklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blacklists.create_email_blacklist(@invalid_attrs)
    end

    test "update_email_blacklist/2 with valid data updates the email_blacklist" do
      email_blacklist = email_blacklist_fixture()
      update_attrs = %{domain: "some updated domain"}

      assert {:ok, %EmailBlacklist{} = email_blacklist} = Blacklists.update_email_blacklist(email_blacklist, update_attrs)
      assert email_blacklist.domain == "some updated domain"
    end

    test "update_email_blacklist/2 with invalid data returns error changeset" do
      email_blacklist = email_blacklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Blacklists.update_email_blacklist(email_blacklist, @invalid_attrs)
      assert email_blacklist == Blacklists.get_email_blacklist!(email_blacklist.id)
    end

    test "delete_email_blacklist/1 deletes the email_blacklist" do
      email_blacklist = email_blacklist_fixture()
      assert {:ok, %EmailBlacklist{}} = Blacklists.delete_email_blacklist(email_blacklist)
      assert_raise Ecto.NoResultsError, fn -> Blacklists.get_email_blacklist!(email_blacklist.id) end
    end

    test "change_email_blacklist/1 returns a email_blacklist changeset" do
      email_blacklist = email_blacklist_fixture()
      assert %Ecto.Changeset{} = Blacklists.change_email_blacklist(email_blacklist)
    end
  end

  describe "ip_address_blacklists" do
    alias Puppies.Blacklists.IPAddressBlacklist

    import Puppies.BlacklistsFixtures

    @invalid_attrs %{ip_address: nil}

    test "list_ip_address_blacklists/0 returns all ip_address_blacklists" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      assert Blacklists.list_ip_address_blacklists() == [ip_address_blacklist]
    end

    test "get_ip_address_blacklist!/1 returns the ip_address_blacklist with given id" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      assert Blacklists.get_ip_address_blacklist!(ip_address_blacklist.id) == ip_address_blacklist
    end

    test "create_ip_address_blacklist/1 with valid data creates a ip_address_blacklist" do
      valid_attrs = %{ip_address: "some ip_address"}

      assert {:ok, %IPAddressBlacklist{} = ip_address_blacklist} = Blacklists.create_ip_address_blacklist(valid_attrs)
      assert ip_address_blacklist.ip_address == "some ip_address"
    end

    test "create_ip_address_blacklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blacklists.create_ip_address_blacklist(@invalid_attrs)
    end

    test "update_ip_address_blacklist/2 with valid data updates the ip_address_blacklist" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      update_attrs = %{ip_address: "some updated ip_address"}

      assert {:ok, %IPAddressBlacklist{} = ip_address_blacklist} = Blacklists.update_ip_address_blacklist(ip_address_blacklist, update_attrs)
      assert ip_address_blacklist.ip_address == "some updated ip_address"
    end

    test "update_ip_address_blacklist/2 with invalid data returns error changeset" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Blacklists.update_ip_address_blacklist(ip_address_blacklist, @invalid_attrs)
      assert ip_address_blacklist == Blacklists.get_ip_address_blacklist!(ip_address_blacklist.id)
    end

    test "delete_ip_address_blacklist/1 deletes the ip_address_blacklist" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      assert {:ok, %IPAddressBlacklist{}} = Blacklists.delete_ip_address_blacklist(ip_address_blacklist)
      assert_raise Ecto.NoResultsError, fn -> Blacklists.get_ip_address_blacklist!(ip_address_blacklist.id) end
    end

    test "change_ip_address_blacklist/1 returns a ip_address_blacklist changeset" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      assert %Ecto.Changeset{} = Blacklists.change_ip_address_blacklist(ip_address_blacklist)
    end
  end

  describe "content_blacklists" do
    alias Puppies.Blacklists.ContentBlacklist

    import Puppies.BlacklistsFixtures

    @invalid_attrs %{content: nil}

    test "list_content_blacklists/0 returns all content_blacklists" do
      content_blacklist = content_blacklist_fixture()
      assert Blacklists.list_content_blacklists() == [content_blacklist]
    end

    test "get_content_blacklist!/1 returns the content_blacklist with given id" do
      content_blacklist = content_blacklist_fixture()
      assert Blacklists.get_content_blacklist!(content_blacklist.id) == content_blacklist
    end

    test "create_content_blacklist/1 with valid data creates a content_blacklist" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %ContentBlacklist{} = content_blacklist} = Blacklists.create_content_blacklist(valid_attrs)
      assert content_blacklist.content == "some content"
    end

    test "create_content_blacklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blacklists.create_content_blacklist(@invalid_attrs)
    end

    test "update_content_blacklist/2 with valid data updates the content_blacklist" do
      content_blacklist = content_blacklist_fixture()
      update_attrs = %{content: "some updated content"}

      assert {:ok, %ContentBlacklist{} = content_blacklist} = Blacklists.update_content_blacklist(content_blacklist, update_attrs)
      assert content_blacklist.content == "some updated content"
    end

    test "update_content_blacklist/2 with invalid data returns error changeset" do
      content_blacklist = content_blacklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Blacklists.update_content_blacklist(content_blacklist, @invalid_attrs)
      assert content_blacklist == Blacklists.get_content_blacklist!(content_blacklist.id)
    end

    test "delete_content_blacklist/1 deletes the content_blacklist" do
      content_blacklist = content_blacklist_fixture()
      assert {:ok, %ContentBlacklist{}} = Blacklists.delete_content_blacklist(content_blacklist)
      assert_raise Ecto.NoResultsError, fn -> Blacklists.get_content_blacklist!(content_blacklist.id) end
    end

    test "change_content_blacklist/1 returns a content_blacklist changeset" do
      content_blacklist = content_blacklist_fixture()
      assert %Ecto.Changeset{} = Blacklists.change_content_blacklist(content_blacklist)
    end
  end

  describe "phone_blacklists" do
    alias Puppies.Blacklists.PhoneBlacklist

    import Puppies.BlacklistsFixtures

    @invalid_attrs %{phone_intl_format: nil, phone_number: nil}

    test "list_phone_blacklists/0 returns all phone_blacklists" do
      phone_blacklist = phone_blacklist_fixture()
      assert Blacklists.list_phone_blacklists() == [phone_blacklist]
    end

    test "get_phone_blacklist!/1 returns the phone_blacklist with given id" do
      phone_blacklist = phone_blacklist_fixture()
      assert Blacklists.get_phone_blacklist!(phone_blacklist.id) == phone_blacklist
    end

    test "create_phone_blacklist/1 with valid data creates a phone_blacklist" do
      valid_attrs = %{phone_intl_format: "some phone_intl_format", phone_number: "some phone_number"}

      assert {:ok, %PhoneBlacklist{} = phone_blacklist} = Blacklists.create_phone_blacklist(valid_attrs)
      assert phone_blacklist.phone_intl_format == "some phone_intl_format"
      assert phone_blacklist.phone_number == "some phone_number"
    end

    test "create_phone_blacklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blacklists.create_phone_blacklist(@invalid_attrs)
    end

    test "update_phone_blacklist/2 with valid data updates the phone_blacklist" do
      phone_blacklist = phone_blacklist_fixture()
      update_attrs = %{phone_intl_format: "some updated phone_intl_format", phone_number: "some updated phone_number"}

      assert {:ok, %PhoneBlacklist{} = phone_blacklist} = Blacklists.update_phone_blacklist(phone_blacklist, update_attrs)
      assert phone_blacklist.phone_intl_format == "some updated phone_intl_format"
      assert phone_blacklist.phone_number == "some updated phone_number"
    end

    test "update_phone_blacklist/2 with invalid data returns error changeset" do
      phone_blacklist = phone_blacklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Blacklists.update_phone_blacklist(phone_blacklist, @invalid_attrs)
      assert phone_blacklist == Blacklists.get_phone_blacklist!(phone_blacklist.id)
    end

    test "delete_phone_blacklist/1 deletes the phone_blacklist" do
      phone_blacklist = phone_blacklist_fixture()
      assert {:ok, %PhoneBlacklist{}} = Blacklists.delete_phone_blacklist(phone_blacklist)
      assert_raise Ecto.NoResultsError, fn -> Blacklists.get_phone_blacklist!(phone_blacklist.id) end
    end

    test "change_phone_blacklist/1 returns a phone_blacklist changeset" do
      phone_blacklist = phone_blacklist_fixture()
      assert %Ecto.Changeset{} = Blacklists.change_phone_blacklist(phone_blacklist)
    end
  end
end
