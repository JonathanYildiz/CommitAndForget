using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CommitAndForget.Essentials;
using CommitAndForget.Model;

namespace CommitAndForget.ViewModel
{
  public class AdminViewModel : NotifyObject
  {
    #region Properties
    public UserModel CurrentUser
    {
      get => Get<UserModel>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public AdminViewModel(UserModel user)
    {
      CurrentUser = user;
    }
    #endregion Constructor
  }
}
