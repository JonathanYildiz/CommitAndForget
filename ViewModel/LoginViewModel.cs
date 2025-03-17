using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Input;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services;
using CommitAndForget.Services.DataProvider;
using CommitAndForget.View;
using CommunityToolkit.Mvvm.Input;

namespace CommitAndForget.ViewModel
{
  public class LoginViewModel : NotifyObject
  {
    #region Properties
    public ObservableCollection<UserModel> UserList
    {
      get => Get<ObservableCollection<UserModel>>();
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

    public UserModel NewUser
    {
      get => Get<UserModel>();
      set => Set(value);
    }
    #endregion Properties

    #region Constructor
    public LoginViewModel()
    {
      CreateCommands();
    }
    #endregion Constuctor

    #region Commands
    private void CreateCommands()
    {
      LoginCommand = new RelayCommand<Window>(Login);
      ShowRegistrationWindowCommand = new RelayCommand(ShowRegistrationWindow);
      ConfirmRegistrationCommand = new RelayCommand<Window>(ConfirmRegistration);
      CancelCommand = new RelayCommand<Window>(Cancel);
    }
    public ICommand LoginCommand { get; private set; }
    public ICommand ShowRegistrationWindowCommand { get; private set; }
    public ICommand ConfirmRegistrationCommand { get; private set; }
    public ICommand CancelCommand { get; private set; }
    #endregion Commands

    #region Methods
    private void Login(Window window)
    {
      try
      {
        if (string.IsNullOrEmpty(Email) && string.IsNullOrEmpty(Password)) // TODO nur zum debuggen, hinterher entfernen
        {
          var view = new MainView();
          view.WindowStartupLocation = WindowStartupLocation.CenterScreen;
          view.DataContext = new AdminViewModel(new UserModel());
          view.Show();
          window?.Close();
          return;
        }

        if (Email == "1" && string.IsNullOrEmpty(Password)) // TODO nur zum debuggen, hinterher entfernen
        {
          var view = new MainView();
          view.WindowStartupLocation = WindowStartupLocation.CenterScreen;
          view.DataContext = new UserViewModel(new UserModel());
          view.Show();
          window?.Close();
          return;
        }

        if (string.IsNullOrEmpty(Email) || string.IsNullOrEmpty(Password))
        {
          MessageBoxService.DisplayMessage("Bitte geben Sie Ihre E-Mail und Ihr Passwort ein.", MessageBoxImage.Warning);
          return;
        }

        UserModel currentUser = UserDataProvider.Login(Email, Password);
        if (currentUser is not null && currentUser.Key > 0) //Benutzer muss gültigen nKey besitzen
        {
          Email = "";
          Password = "";

          var view = new MainView();
          view.WindowStartupLocation = WindowStartupLocation.CenterScreen;

          if (currentUser.IsAdmin)
            view.DataContext = new AdminViewModel(currentUser);
          else
            view.DataContext = new UserViewModel(currentUser);

          view.Show();

          window?.Close();
        }
        else
        {
          MessageBoxService.DisplayMessage("E-Mail oder Passwort ist falsch.", MessageBoxImage.Warning);
          Password = "";
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }

    }

    private void ShowRegistrationWindow()
    {
      try
      {
        NewUser = new UserModel();

        var view = new RegistrationView();
        view.WindowStartupLocation = WindowStartupLocation.CenterScreen;
        view.DataContext = this;
        view.Show();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void ConfirmRegistration(Window window)
    {
      try
      {
        UserModel createdUser = UserDataProvider.Register(NewUser);
        if (createdUser is null)
          return;

        if (createdUser is not null && createdUser.Key > 0)
        {
          Email = NewUser.Email;
          Password = NewUser.Password;
          window?.Close();
        }
        else
        {
          MessageBoxService.DisplayMessage("Benutzer konnte nicht angelegt werden.", MessageBoxImage.Error);
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void Cancel(Window window) => window?.Close();

    #endregion Methods
  }
}