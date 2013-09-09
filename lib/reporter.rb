class Reporter
  def on_see_link(uri)
  end
  def on_visit(page)
    page.puts
  end
  def exit_code
    0
  end
end