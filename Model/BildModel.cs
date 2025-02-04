using System.Windows.Media;
using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class BildModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public ImageSource Bild
    {
      get => Get<ImageSource>();
      set => Set(value);
    }

    public bool Freigeschaltet
    {
      get => Get<bool>();
      set => Set(value);
    }

    public DateTime Erstelldatum
    {
      get => Get<DateTime>();
      set => Set(value);
    }

    public bool ContestGewonnen
    {
      get => Get<bool>();
      set => Set(value);
    }
    #endregion Properties
  }
}
