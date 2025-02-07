using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Controls;
using System.Windows.Input;
using System.Windows.Threading;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.View.UserViews;
using CommunityToolkit.Mvvm.Input;

namespace CommitAndForget.ViewModel
{
  public class UserViewModel : NotifyObject
  {
    #region Properties
    public UserModel CurrentUser
    {
      get => Get<UserModel>();
      set => Set(value);
    }

    public Frame MainFrame
    {
      get => Get<Frame>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public UserViewModel(UserModel user)
    {
      CurrentUser = user;
      CreateCommands();
    }
    #endregion Constructor

    #region Commands
    private void CreateCommands()
    {
      NavigateToUserSelectionCommand = new RelayCommand(NavigateToUserSelection);
      NavigateToUserOrderCommand = new RelayCommand(NavigateToUserOrder);
      NavigateBackCommand = new RelayCommand(NavigateBack);
    }
    public ICommand NavigateToUserSelectionCommand { get; private set; }
    public ICommand NavigateToUserOrderCommand { get; private set; }
    public ICommand NavigateBackCommand { get; private set; }
    #endregion Commands

    #region Methods
    private void NavigateToUserSelection()
    {
      MainFrame?.Navigate(new UserSelectionView());
    }

    private void NavigateToUserOrder()
    {
      MainFrame?.Navigate(new UserOrderView());
    }

    private void NavigateBack()
    {
      if (MainFrame.NavigationService.CanGoBack)
        MainFrame.NavigationService.GoBack();
    }
    #endregion Methods
  }
}
