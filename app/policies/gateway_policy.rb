class GatewayPolicy < ApplicationPolicy
  def admin_namespace?
    user.has_role?(:admin) || user.has_role?(:superadmin)
  end

  def teacher_namespace?
    user.has_role?(:teacher)
  end

  def student_namespace?
    user.has_role?(:student)
  end

  def super_admin_namespace?
    user.has_role?(:superadmin)
  end

  def financial_namespace?
    user.has_role?(:financial)
  end
end
