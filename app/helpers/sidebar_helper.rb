module SidebarHelper
  def sidebar_links
    [
      { name: "Dashboard", path: admin_dashboard_path, icon: "layout-dashboard" },
      { name: "Crawl Sources", path: admin_crawl_sources_path, icon: "globe" },
      { name: "Lead Generation", path: admin_potential_companies_path, icon: "search" },
      { name: "Email Outreach", path: admin_emails_path, icon: "mail" },
      { name: "Sales Pipeline", path: admin_sales_path, icon: "bar-chart3" },
      { name: "Proposals", path: admin_dashboard_path, icon: "file" },
      { name: "Team Management", path: admin_dashboard_path, icon: "users" }
    ]
  end
end
