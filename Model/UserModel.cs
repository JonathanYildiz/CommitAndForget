using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class UserModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public string FirstName
    {
      get => Get<string>();
      set => Set(value);
    }

    public string LastName
    {
      get => Get<string>();
      set => Set(value);
    }

    public string Street
    {
      get => Get<string>();
      set => Set(value);
    }

    public string HouseNumber
    {
      get => Get<string>();
      set => Set(value);
    }

    public string PostalCode
    {
      get => Get<string>();
      set => Set(value);
    }

    public string City
    {
      get => Get<string>();
      set => Set(value);
    }

    public string Email
    {
      get => Get<string>();
      set => Set(value);
    }

    public string Password
    {
      get => Get<string>();
      set => Set(value);
    }

    public bool IsAdmin
    {
      get => Get<bool>();
      set => Set(value);
    }
    #endregion Properties
  }
}
