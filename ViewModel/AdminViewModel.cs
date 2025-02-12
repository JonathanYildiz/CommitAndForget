using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Input;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services.DataProvider;
using CommitAndForget.View.AdminViews;
using CommunityToolkit.Mvvm.Input;

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
    public UserModel SelectedUser
    {
      get => Get<UserModel>();
      set => Set(value);
    }
    public ObservableCollection<UserModel> UserList
    {
      get => Get<ObservableCollection<UserModel>>();
      set => Set(value);
    }
    public Frame MainFrame
    {
      get => Get<Frame>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public AdminViewModel(UserModel user)
    {
      CurrentUser = user;
      UserList = new ObservableCollection<UserModel>();
      CreateCommands();
    }
    #endregion Constructor

    #region Commands
    private void CreateCommands()
    {
      NavigateToUserManagementCommand = new RelayCommand(NavigateToUserManagement);
      NavigateToProductManagementCommand = new RelayCommand(NavigateToProductManagement);
      NavigateToOrderManagementCommand = new RelayCommand(NavigateToOrderManagement);
      NavigateToMenuManagementCommand = new RelayCommand(NavigateToMenuManagement);
      NavigateToImageManagementCommand = new RelayCommand(NavigateToImageManagement);
      NavigateBackCommand = new RelayCommand(NavigateBack);
      EditUserCommand = new RelayCommand<UserModel>(EditUser);
      DeleteUserCommand = new RelayCommand<UserModel>(DeleteUser);
      SaveUserCommand = new RelayCommand<Window>(SaveUser);
      CancelUserCommand = new RelayCommand<Window>(CancelUser);
    }
    public ICommand NavigateToUserManagementCommand { get; private set; }
    public ICommand NavigateToProductManagementCommand { get; private set; }
    public ICommand NavigateToOrderManagementCommand { get; private set; }
    public ICommand NavigateToMenuManagementCommand { get; private set; }
    public ICommand NavigateToImageManagementCommand { get; private set; }
    public ICommand NavigateBackCommand { get; private set; }
    public ICommand EditUserCommand { get; private set; }
    public ICommand DeleteUserCommand { get; private set; }
    public ICommand SaveUserCommand { get; private set; }
    public ICommand CancelUserCommand { get; private set; }
    #endregion Commands

    #region Methods
    private void NavigateToUserManagement()
    {
      UserList = UserDataProvider.LoadUser();
      MainFrame?.Navigate(new UserManagementView() { DataContext = this });
    }
    private void NavigateToProductManagement() => MainFrame?.Navigate(new ProductManagementView() { DataContext = this });
    private void NavigateToOrderManagement() => MainFrame?.Navigate(new OrderManagementView() { DataContext = this });
    private void NavigateToMenuManagement() => MainFrame?.Navigate(new MenuManagementView() { DataContext = this });
    private void NavigateToImageManagement() => MainFrame?.Navigate(new ImageManagementView() { DataContext = this });
    private void NavigateBack()
    {
      if (MainFrame.NavigationService.CanGoBack)
        MainFrame.NavigationService.GoBack();
    }
    private void EditUser(UserModel? user)
    {
      if (user is not null)
      {
        SelectedUser = user;
        var editWindow = new EditUserView() { DataContext = this };
        editWindow.WindowStartupLocation = WindowStartupLocation.CenterScreen;
        editWindow.ShowDialog();
      }
    }
    private void DeleteUser(UserModel? user)
    {
      if (user is not null)
      {
        UserDataProvider.DeleteUser(user.Key);
        UserList.Remove(user);
      }
    }
    private void SaveUser(Window? editWindow)
    {
      if (SelectedUser is not null)
        UserDataProvider.UpdateUser(SelectedUser);

      SelectedUser = null;
      editWindow?.Close();
    }
    private void CancelUser(Window? editWindow)
    {
      SelectedUser = null;
      editWindow?.Close();
    }
    #endregion Methods
  }
}
