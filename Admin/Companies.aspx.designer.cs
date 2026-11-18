namespace SkillLinksX.Admin
{
    public partial class Companies
    {
        protected global::System.Web.UI.WebControls.Label lblAdminCompanyStatus;
        protected global::System.Web.UI.WebControls.TextBox txtSearchCompany;
        protected global::System.Web.UI.WebControls.DropDownList ddlIndustryFilter;
        protected global::System.Web.UI.WebControls.DropDownList ddlLocationFilter;
        protected global::System.Web.UI.WebControls.DropDownList ddlStatusFilter;
        protected global::System.Web.UI.WebControls.LinkButton btnClearFilters;
        protected global::System.Web.UI.WebControls.Repeater rptCompaniesTable;
        protected global::System.Web.UI.WebControls.Repeater rptPopularIndustries;
        protected global::System.Web.UI.WebControls.Repeater rptTopLocations;
        protected global::System.Web.UI.WebControls.HiddenField hdnSelectedCompanyId;
        protected global::System.Web.UI.WebControls.Button btnSidebarApprove;
        protected global::System.Web.UI.WebControls.Button btnSidebarReject;
    }
}
