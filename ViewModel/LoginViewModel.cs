using System.Collections.ObjectModel;
using CommitAndForget.Essentials;
using CommitAndForget.Model;
using CommitAndForget.Services.DataProvider;

namespace CommitAndForget.ViewModel
{
  public class LoginViewModel : NotifyObject
  {
    ObservableCollection<TestModel> TestList
    {
      get => Get<ObservableCollection<TestModel>>();
      set => Set(value);
    }

    private string m_TestString;
    public string TestString
    {
      get
      {
        return m_TestString;
      }
      set
      {
        if (m_TestString != value)
        {
          m_TestString = value;
          OnPropertyChanged();
        }
      }
    }
    


    public LoginViewModel()
    {
      TestList = TestDataProvider.LoadTestData();
    }

  }
}
