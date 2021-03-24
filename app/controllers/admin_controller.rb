class AdminController < ActionController::API
    before_action :authorized
  
    def encode_token(payload)
      JWT.encode(payload, 'H%fBpaXKtrQV9dX`9UNtND3q&W3')
    end
  
    def auth_header
      # { Authorization: 'Bearer <token>' }
      request.headers['Authorization']
    end
  
    def decoded_token
      if auth_header
        token = auth_header.split(' ')[1]
        # header: { 'Authorization': 'Bearer <token>' }
        begin
          JWT.decode(token, 'H%fBpaXKtrQV9dX`9UNtND3q&W3', true, algorithm: 'HS256')
        rescue JWT::DecodeError
          nil
        end
      end
    end
  
    def current_admin
      if decoded_token
        admin_id = decoded_token[0]['admin_id']
        @admin = Admin.find_by(uuid: admin_id)
      end
    end
  
    def logged_in?
      !!current_admin
    end
  
    def authorized
      render json: { message: 'Please log in' }, status: :unauthorized unless logged_in?
    end
  end
  