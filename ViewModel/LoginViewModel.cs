using System.Collections.ObjectModel;
using System.Windows;
using System.Windows.Input;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
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
      //Alle Benutzer laden
      BenutzerListe = BenutzerDataProvider.LoadBenutzer();
      CreateCommands();
    }
    #endregion Konstuktor

    #region Commands
    private void CreateCommands()
    {
      LoginCommand = new RelayCommand(Login);
      RegistrierenCommand = new RelayCommand(Registrieren);
    }
    public ICommand LoginCommand { get; private set; }
    public ICommand RegistrierenCommand { get; private set; }
    #endregion Commands

    #region Methoden
    private void Login()
    {
      if(string.IsNullOrEmpty(Mail) || string.IsNullOrEmpty(Passwort))
      {
        MessageBox.Show("Bitte geben Sie Ihre Mail und Ihr Passwort ein", "Fehler", MessageBoxButton.OK, MessageBoxImage.Warning);
        return;
      }

      foreach (var benutzer in BenutzerListe)
      {       
        if (benutzer.Mail == Mail && benutzer.Passwort == Passwort)
        {
          //Login erfolgreich
          //TODO JYI Login handlen
        }
      }
    }

    private void Registrieren()
    {
      // Registrierung handlen
    }
    #endregion Methoden
  }
}