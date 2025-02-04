using System.Collections.ObjectModel;
using System.Data;
using System.Windows;
using CommitAndForget.Model;

namespace CommitAndForget.Services.DataProvider
{
  public static class TestDataProvider
  {
    public static ObservableCollection<TestModel> LoadTestData()
    {
      try
      {
        DataTable dt = DataBaseService.ExecuteSP("spTest");
        var testList = new ObservableCollection<TestModel>();

        if (dt is not null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            var m = new TestModel();

            m.TestInt = row["COLUMN1"] != DBNull.Value ? (int)row["COLUMN1"] : default;
            m.TestString = row["COLUMN2"] != DBNull.Value ? row["COLUMN2"].ToString() ?? string.Empty : string.Empty;

            testList.Add(m);
          }

        }
        return testList;
      }
      catch (Exception ex)
      {
        MessageBox.Show($"Es ist ein Fehler aufgetreten: {ex.Message}", "Fehler", MessageBoxButton.OK, MessageBoxImage.Error);
        return [];
      }
    }
  }
}
