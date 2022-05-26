defmodule Puppies.BlacklistsTest do
  use Puppies.DataCase

  alias Puppies.Blacklists
  alias Puppies.Blacklists.{Domain, IPAddress, Content, Phone}

  describe "domain_blacklists" do
    import Puppies.BlacklistsFixtures

    @invalid_attrs %{domain: nil}

    test "list_domain_blacklists/0 returns all domain_blacklists" do
      domains = domain_blacklist_fixture()
      assert Blacklists.get_all_blacklisted_items(Domain) == [domains]
    end

    test "create_domain_blacklist/1 with valid data creates a domain_blacklist" do
      valid_attrs = %{domain: "some domain"}

      assert {:ok, %Domain{} = domain_blacklist} = Blacklists.create_domain_blacklist(valid_attrs)

      assert domain_blacklist.domain == "some domain"
    end

    test "create_domain_blacklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blacklists.create_domain_blacklist(@invalid_attrs)
    end

    test "delete_domain_blacklist/1 deletes the domain_blacklist" do
      domain_blacklist = domain_blacklist_fixture()
      assert {:ok, %Domain{}} = Blacklists.delete_domain_blacklist(domain_blacklist)

      assert_raise Ecto.NoResultsError, fn ->
        Blacklists.get_domain_blacklist!(domain_blacklist.id)
      end
    end

    test "change_domain_blacklist/1 returns a domain_blacklist changeset" do
      domain_blacklist = domain_blacklist_fixture()
      assert %Ecto.Changeset{} = Blacklists.change_domain_blacklist(domain_blacklist)
    end
  end

  describe "ip_address_blacklists" do
    import Puppies.BlacklistsFixtures

    @invalid_attrs %{ip_address: nil}

    test "list_ip_address_blacklists/0 returns all ip_address_blacklists" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      assert Blacklists.get_all_blacklisted_items(IPAddress) == [ip_address_blacklist]
    end

    test "get_ip_address_blacklist!/1 returns the ip_address_blacklist with given id" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      assert Blacklists.get_ip_address_blacklist!(ip_address_blacklist.id) == ip_address_blacklist
    end

    test "create_ip_address_blacklist/1 with valid data creates a ip_address_blacklist" do
      valid_attrs = %{ip_address: "some ip_address"}

      assert {:ok, %IPAddress{} = ip_address_blacklist} =
               Blacklists.create_ip_address_blacklist(valid_attrs)

      assert ip_address_blacklist.ip_address == "some ip_address"
    end

    test "create_ip_address_blacklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blacklists.create_ip_address_blacklist(@invalid_attrs)
    end

    test "delete_ip_address_blacklist/1 deletes the ip_address_blacklist" do
      ip_address_blacklist = ip_address_blacklist_fixture()

      assert {:ok, %IPAddress{}} = Blacklists.delete_ip_address_blacklist(ip_address_blacklist)

      assert_raise Ecto.NoResultsError, fn ->
        Blacklists.get_ip_address_blacklist!(ip_address_blacklist.id)
      end
    end

    test "change_ip_address_blacklist/1 returns a ip_address_blacklist changeset" do
      ip_address_blacklist = ip_address_blacklist_fixture()
      assert %Ecto.Changeset{} = Blacklists.change_ip_address_blacklist(ip_address_blacklist)
    end
  end

  describe "content_blacklists" do
    import Puppies.BlacklistsFixtures

    @invalid_attrs %{content: nil}

    test "list_content_blacklists/0 returns all content_blacklists" do
      content_blacklist = content_blacklist_fixture()
      assert Blacklists.get_all_blacklisted_items(Content) == [content_blacklist]
    end

    test "get_content_blacklist!/1 returns the content_blacklist with given id" do
      content_blacklist = content_blacklist_fixture()
      assert Blacklists.get_content_blacklist!(content_blacklist.id) == content_blacklist
    end

    test "create_content_blacklist/1 with valid data creates a content_blacklist" do
      valid_attrs = %{content: "some content"}

      assert {:ok, %Content{} = content_blacklist} =
               Blacklists.create_content_blacklist(valid_attrs)

      assert content_blacklist.content == "some content"
    end

    test "create_content_blacklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blacklists.create_content_blacklist(@invalid_attrs)
    end

    test "delete_content_blacklist/1 deletes the content_blacklist" do
      content_blacklist = content_blacklist_fixture()
      assert {:ok, %Content{}} = Blacklists.delete_content_blacklist(content_blacklist)

      assert_raise Ecto.NoResultsError, fn ->
        Blacklists.get_content_blacklist!(content_blacklist.id)
      end
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
      assert Blacklists.get_all_blacklisted_items(Phone) == [phone_blacklist]
    end

    test "get_phone_blacklist!/1 returns the phone_blacklist with given id" do
      phone_blacklist = phone_blacklist_fixture()
      assert Blacklists.get_phone_blacklist!(phone_blacklist.id) == phone_blacklist
    end

    test "create_phone_blacklist/1 with valid data creates a phone_blacklist" do
      valid_attrs = %{
        phone_number: "1616444444"
      }

      assert {:ok, %Phone{} = phone_blacklist} = Blacklists.create_phone_blacklist(valid_attrs)

      assert phone_blacklist.phone_number == "1616444444"
    end

    test "create_phone_blacklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Blacklists.create_phone_blacklist(@invalid_attrs)
    end

    test "delete_phone_blacklist/1 deletes the phone_blacklist" do
      phone_blacklist = phone_blacklist_fixture()
      assert {:ok, %Phone{}} = Blacklists.delete_phone_blacklist(phone_blacklist)

      assert_raise Ecto.NoResultsError, fn ->
        Blacklists.get_phone_blacklist!(phone_blacklist.id)
      end
    end

    test "change_phone_blacklist/1 returns a phone_blacklist changeset" do
      phone_blacklist = phone_blacklist_fixture()
      assert %Ecto.Changeset{} = Blacklists.change_phone_blacklist(phone_blacklist)
    end
  end
end
