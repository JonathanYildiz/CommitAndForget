using System.Collections.ObjectModel;
using System.Data;
using System.Windows;
using CommitAndForget.Model;

namespace CommitAndForget.Services.DataProvider
{
  public static class IngredientDataProvider
  {
    public static ObservableCollection<IngredientModel> LoadIngredients(int productLink)
    {
      try
      {
        var parameters = new Dictionary<string, object>
        {
          { "p_ProductLink", productLink }
        };

        DataTable dt = DataBaseService.ExecuteSP("spGetIngredients", parameters);
        var ingredientList = new ObservableCollection<IngredientModel>();

        if (dt is not null && dt.Rows.Count > 0)
        {
          foreach (DataRow row in dt.Rows)
          {
            var ingredient = new IngredientModel();
            ingredient.Key = row["ingredient_nKey"] != DBNull.Value ? (int)row["ingredient_nKey"] : default;
            ingredient.Name = row["ingredient_szName"] != DBNull.Value ? row["ingredient_szName"].ToString() ?? string.Empty : string.Empty;
            ingredient.Quantity = row["ingredient_nQuantity"] != DBNull.Value ? (int)row["ingredient_nQuantity"] : default;

            ingredientList.Add(ingredient);
          }
        }
        return ingredientList;
      }
      catch (Exception ex)
      {
        MessageBoxService.DisplayMessage(ex.Message, MessageBoxImage.Error);
        return new ObservableCollection<IngredientModel>();
      }
    }
  }
}
