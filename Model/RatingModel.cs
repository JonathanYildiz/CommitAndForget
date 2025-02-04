using CommitAndForget.Essentials;

namespace CommitAndForget.Model
{
  public class RatingModel : NotifyObject
  {
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

    public int BenutzerLink
    {
      get => Get<int>();
      set => Set(value);
    }

    public int BildLink
    {
      get => Get<int>();
      set => Set(value);
    }
    #endregion Properties
  }
}
