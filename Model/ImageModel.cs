using System.Windows.Media;
using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class ImageModel : NotifyObject
  {
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public ImageSource Image
    {
      get => Get<ImageSource>();
      set => Set(value);
    }

    public bool Approved
    {
      get => Get<bool>();
      set => Set(value);
    }

    public DateTime CreationDate
    {
      get => Get<DateTime>();
      set => Set(value);
    }

    public bool ContestWon
    {
      get => Get<bool>();
      set => Set(value);
    }
    #endregion Properties
  }
}
