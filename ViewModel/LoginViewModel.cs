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
    public ObservableCollection<BenutzerModel> BenutzerListe
    {
      get => Get<ObservableCollection<BenutzerModel>>();
      set => Set(value);
    }

    public string Mail
    {
      get => Get<string>();
      set => Set(value);
    }

    public string Passwort
    {
      get => Get<string>();
      set => Set(value);
    }

    public BenutzerModel NeuerBenutzer
    {
      get => Get<BenutzerModel>();
      set => Set(value);
    }
    #endregion Properties

    #region Konstruktor
    public LoginViewModel()
    {
      CreateCommands();
    }
    #endregion Konstuktor

    #region Commands
    private void CreateCommands()
    {
      LoginCommand = new RelayCommand<Window>(Login);
      ShowRegistrierenCommand = new RelayCommand(ShowRegistrieren);
      ConfirmRegistrierenCommand = new RelayCommand<Window>(ConfirmRegistrieren);
      CancelCommand = new RelayCommand<Window>(Cancel);
    }
    public ICommand LoginCommand { get; private set; }
    public ICommand ShowRegistrierenCommand { get; private set; }
    public ICommand ConfirmRegistrierenCommand { get; private set; }
    public ICommand CancelCommand { get; private set; }
    #endregion Commands

    #region Methoden
    private void Login(Window window)
    {
      try
      {
        if (string.IsNullOrEmpty(Mail) || string.IsNullOrEmpty(Passwort))
        {
          MessageBoxService.DisplayMessage("Bitte geben Sie Ihre E-Mail und Ihr Passwort ein.", MessageBoxImage.Warning);
          return;
        }

        BenutzerModel aktuellerBenutzer = BenutzerDataProvider.Login(Mail, Passwort);
        if (aktuellerBenutzer is not null && aktuellerBenutzer.Key > 0) //Benutzer muss gültigen nKey besitzen
        {
          Mail = "";
          Passwort = "";

          // Neue View erstellen
          // DataContext zuweisen -> new MacAppleViewModel(aktuellerBenutzer);
          // NeueView.Show();

          window?.Close();
        }
        else
        {
          MessageBoxService.DisplayMessage("E-Mail oder Passwort ist falsch.", MessageBoxImage.Warning);
          Passwort = "";
        }
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }

    }

    private void ShowRegistrieren()
    {
      try
      {
        NeuerBenutzer = new BenutzerModel();

        var view = new RegistrierenView();
        view.DataContext = this;
        view.Show();
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
      }
    }

    private void ConfirmRegistrieren(Window window)
    {
      try
      {
        BenutzerModel angelegterBenutzer = BenutzerDataProvider.Registrieren(NeuerBenutzer);

        if (angelegterBenutzer is not null && angelegterBenutzer.Key > 0)
        {
          Mail = NeuerBenutzer.Mail;
          Passwort = NeuerBenutzer.Passwort;
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

    #endregion Methoden
  }
}