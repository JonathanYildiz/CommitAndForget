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

    #region Constructor
    public UserModel() { }
    public UserModel (UserModel user)
    {
      Key = user.Key;
      FirstName = user.FirstName;
      LastName = user.LastName;
      Street = user.Street;
      HouseNumber = user.HouseNumber;
      PostalCode = user.PostalCode;
      City = user.City;
      Email = user.Email;
      Password = user.Password;
      IsAdmin = user.IsAdmin;
    }
    #endregion Constructor

    #region Methods
    public void RollbackChanges(UserModel backupUser)
    {
      Key = backupUser.Key;
      FirstName = backupUser.FirstName;
      LastName = backupUser.LastName;
      Street = backupUser.Street;
      HouseNumber = backupUser.HouseNumber;
      PostalCode = backupUser.PostalCode;
      City = backupUser.City;
      Email = backupUser.Email;
      Password = backupUser.Password;
      IsAdmin = backupUser.IsAdmin;
    }
    #endregion Methods
  }
}
