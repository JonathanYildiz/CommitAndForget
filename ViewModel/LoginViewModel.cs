using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Input;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services;
using CommitAndForget.Services.DataProvider;
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
      RegistrierenCommand = new RelayCommand(Registrieren);
    }
    public ICommand LoginCommand { get; private set; }
    public ICommand RegistrierenCommand { get; private set; }
    #endregion Commands

    #region Methoden
    private void Login(Window window)
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

        //TODO JYI Login handlen
      }
      else
      {
        MessageBoxService.DisplayMessage("E-Mail oder Passwort ist falsch.", MessageBoxImage.Warning);
        Passwort = "";
      }

    }

    private void Registrieren()
    {
      // Registrierung handlen
    }
    #endregion Methoden
  }
}