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
        protected global::System.Web.UI.WebControls.HiddenField hdnSelectedCompanyId;
        protected global::System.Web.UI.WebControls.Button btnSidebarApprove;
        protected global::System.Web.UI.WebControls.Button btnSidebarPending;
        protected global::System.Web.UI.WebControls.Button btnSidebarRevoke;

        // Add Company Modal Controls
        protected global::System.Web.UI.WebControls.TextBox txtNewCompName;
        protected global::System.Web.UI.WebControls.TextBox txtNewRecruiterName;
        protected global::System.Web.UI.WebControls.TextBox txtNewCompEmail;
        protected global::System.Web.UI.WebControls.TextBox txtNewCompPassword;
        protected global::System.Web.UI.WebControls.TextBox txtNewCompPhone;
        protected global::System.Web.UI.WebControls.DropDownList ddlNewCompIndustry;
        protected global::System.Web.UI.WebControls.TextBox txtNewCompCity;
        protected global::System.Web.UI.WebControls.DropDownList ddlNewCompState;
        protected global::System.Web.UI.WebControls.TextBox txtNewCompAddress;
        protected global::System.Web.UI.WebControls.TextBox txtNewCompWebsite;
        protected global::System.Web.UI.WebControls.DropDownList ddlNewCompEmpCount;
        protected global::System.Web.UI.WebControls.DropDownList ddlNewCompStatus;
        protected global::System.Web.UI.WebControls.Label lblNewCompError;
        protected global::System.Web.UI.WebControls.Button btnSaveNewCompany;
    }
}
