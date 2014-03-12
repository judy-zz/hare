<% module_namespacing do -%>
class <%= class_name %>Message < Hare::Message
  exchange ""
  routing_key ""
end
<% end -%>
