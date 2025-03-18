using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class RatingModel : NotifyObject
  { // Todo löschen, wenn nicht benötigt
    #region Properties
    public int Key
    {
      get => Get<int>();
      set => Set(value);
    }

    public int Rating
    {
      get => Get<int>();
      set => Set(value);
    }

    public int UserLink
    {
      get => Get<int>();
      set => Set(value);
    }

    public int ImageLink
    {
      get => Get<int>();
      set => Set(value);
    }
    #endregion Properties
  }
}
