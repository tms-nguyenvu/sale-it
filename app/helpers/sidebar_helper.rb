module SidebarHelper
  def sidebar_links
    [
      { name: "Home", path: admin_dashboard_path, icon: "layout-dashboard" },
      { name: "Companies", path: admin_companies_path, icon: "building-2" },
      { name: "Leads", path: admin_leads_path, icon: "users" },
      { name: "Crawl Sources", path: admin_crawl_sources_path, icon: "globe" }
    ]
  end
end
