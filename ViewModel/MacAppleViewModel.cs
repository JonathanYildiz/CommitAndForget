using CommitAndForget.Essentials;
using CommitAndForget.Model;

namespace CommitAndForget.ViewModel
{
  public class MacAppleViewModel : NotifyObject
  {
    #region Properties
    public BenutzerModel AktuellerBenutzer
    {
      get => Get<BenutzerModel>();
      set => Set(value);
    }
    #endregion Properties

    #region Konstruktor
    public MacAppleViewModel(BenutzerModel aktuellerBenutzer)
    {
      AktuellerBenutzer = aktuellerBenutzer;
    }
    #endregion Konstruktor
  }
}
