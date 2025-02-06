using CommitAndForget.Essentials;
using CommitAndForget.Model;

namespace CommitAndForget.ViewModel
{
  public class MacAppleViewModel : NotifyObject
  {
    #region Properties
    public UserModel CurrentUser
    {
      get => Get<UserModel>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public MacAppleViewModel(UserModel currentUser)
    {
      CurrentUser = currentUser;
    }
    #endregion constructor
  }
}
